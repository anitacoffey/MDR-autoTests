####################
# Step Definitions #
####################
And('I select {string} from the trade panel') do |mode|
  valid_modes = %w[market watch holdings]
  valid_mode = valid_modes.select { |m| m == mode }

  if valid_mode.empty?
    raise "Invalid select mode. Valid selection are #{valid_modes}"
  end

  elements = TradePage.new
  elements.left_mode_selector.select(mode)
end

And('I select a contract in {string} of product type {string} and metal type {string}') do |hub, product, metal|
  valid_metals = %w[gold silver platinum]
  valid_metal = valid_metals.select { |m| m == metal }

  if valid_metal.empty?
    raise "Invalid select mode. Valid selection are #{valid_modes}"
  end

  elements = TradePage.new
  elements.left_filter_toggle.click unless elements.left_product_filters.exists?

  metal_map = {
    'gold' => 'string:1',
    'silver' => 'string:2',
    'platinum' => 'string:3'
  }

  elements.left_metal_selector.select(metal_map[metal])
  elements.left_hub_selector.select(hub)

  contract = elements.left_panel_contracts.h2(text: product)
  raise 'The target contract does not exist in the hub' unless contract.exists?

  contract.click
end

And('I place a {string} market order in the selected contract for a quantity of {int}') do |direction, quantity|
  elements = TradePage.new

  if direction == 'buy'
    elements.buy_button.click
  else
    elements.sell_button.click
  end

  # Animations are the worst, this sleep awaits the panel to pop completely
  sleep 1

  elements.market_order_button.click
  elements.order_quantity_control.set(quantity)
  elements.review_order_button.click
  elements.submit_order_button.click
end

And(
  'I validate the matched order in the database '\
  'with order details {int}, {string}, {int}, {string} for user set {string}'
) do |contract_id, direction, quantity, order_type, user_set|
  user = YamlLoader.user_info(user_set)
  username = user['username']

  # Give the immediate settlement service 2 seconds to create trade transactions for the order
  sleep 2

  account_uuid = find_account_uuid(username)
  order = find_order(account_uuid, contract_id, direction, quantity)

  raise 'The order has not been filled' unless order.status == 'fill'

  raise 'The order was of the wrong type' unless order.orderType == order_type

  # Ensure this is the correct order by making sure it occured in the last 20 seconds
  order_created = order.createdAt.to_i
  current_time = Time.now.to_i

  unless order_created.between?(current_time - 20, current_time + 20)
    raise 'The orders timestamp is incorrect'
  end

  # Check the balance history to ensure holdings balance moved as expected
  order_matches = find_order_matches(order.id, direction)
  trade_transactions = order_matches.map do |order_match|
    find_trade_transaction(order_match.id, account_uuid)
  end

  recorded_quantity = trade_transactions.map(&:quantity)
  unless recorded_quantity[0] == quantity.to_i
    raise 'The quantity accumlated in the trade transactions does not equal the test condition'
  end

  trade_transactions.each do |tt|
    recorded_cost = tt.settlementAmount
    account_balance_movement = account_balance_change_with_trade_transaction(tt.id, account_uuid, direction, 2)

    qty = tt.quantity
    holdings_balance_movement = holdings_balance_change_with_trade_transaction(tt.id, account_uuid, direction, contract_id)

    # We invert the cost if it is a buy order as the account balance should go down
    # We invert the qty if it is a sell order as the holdings balance should go down
    if direction == 'buy'
      recorded_cost = -recorded_cost
    else
      qty = -qty
    end

    unless recorded_cost == account_balance_movement
      raise 'Trade transaction settlement amount does not match balance movement'
    end

    unless qty == holdings_balance_movement
      raise 'Trade transaction quantity amount does not match balance movement'
    end
  end
end

##################
# Common Methods #
##################
def find_account_uuid(username)
  AccountUser.where(username: username)[0].account.uuid
end

def find_order(account_uuid, contract_id, direction, quantity)
  Order
    .where(
      accountId: account_uuid,
      direction: direction,
      contractId: contract_id.to_i,
      quantity: quantity
    )
    .order(createdAt: 'DESC')
    .limit(1)[0]
end

def find_order_matches(order_id, direction)
  if direction == 'buy'
    OrderMatch.where(buyOrderId: order_id)
  else
    OrderMatch.where(sellOrderId: order_id)
  end
end

def find_trade_transaction(order_match_id, account_id)
  TradeTransaction.where(
    orderMatchId: order_match_id,
    accountId: account_id
  )[0]
end

def account_balance_change_with_trade_transaction(trade_transaction_id, account_id, _direction, marketplace_id)
  account_balance = Balance.where(
    marketplaceId: marketplace_id,
    balanceTypeId: 'Account',
    accountId: account_id
  )[0]

  balance_adjustment = BalanceAdjustment.where(
    transactionId: trade_transaction_id,
    balanceId: account_balance.id
  )[0]

  account_balance_history_after = BalanceHistory.where(
    balanceAdjustmentId: balance_adjustment.id
  )[0]

  account_balance_history_all = BalanceHistory
                                .where(
                                  balanceId: account_balance.id
                                )
                                .order(id: 'DESC')

  account_balance_history_before = nil
  account_balance_history_all.each do |bh|
    if bh.id < account_balance_history_after.id
      account_balance_history_before = bh
      break
    end
  end

  account_balance_history_after.total - account_balance_history_before.total
end

def holdings_balance_change_with_trade_transaction(trade_transaction_id, account_id, _direction, contract_id)
  holdings_balance = Balance.where(
    contractId: contract_id,
    balanceTypeId: 'Holdings',
    accountId: account_id
  )[0]

  balance_adjustment = BalanceAdjustment.where(
    transactionId: trade_transaction_id,
    balanceId: holdings_balance.id
  )[0]

  holdings_balance_history_after = BalanceHistory.where(
    balanceAdjustmentId: balance_adjustment.id
  )[0]

  holdings_balance_history_all = BalanceHistory
                                 .where(
                                   balanceId: holdings_balance.id
                                 )
                                 .order(id: 'DESC')

  holdings_balance_history_before = nil
  holdings_balance_history_all.each do |bh|
    if bh.id < holdings_balance_history_after.id
      holdings_balance_history_before = bh
      break
    end
  end

  holdings_balance_history_after.total - holdings_balance_history_before.total
end
