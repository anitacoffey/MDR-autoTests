####################
# Step Definitions #
####################
And('I select a contract in {string} and metal type {string}') do |hub, metal|

  elements = TradePage.new
  #elements.left_filter_toggle.click unless elements.left_product_filters.exists?
  if hub == "Dubai"
    elements.dubai_hub.click()
    if metal == "Gold 1kg Bar 995"
      elements.buy_kg995_Gold_Dubai.click()
    elsif metal == "Gold Wholesale AAU 10kg"
      elements.sell_wholesale_Gold_Dubai.click()

elsif hub == "Hong Kong"
  elements.hongKong_hub.click()
  if metal == "Gold 10oz Swiss Bar"
    elements.buy_Swiss_10oz_Gold_HongKong.click()

elsif hub == "London"
  elements.london_hub.click()

elsif hub == "New York"
  elements.newYork_hub.click()

elsif hub == "Singapore"
  elements.singapore_hub.click()

elsif hub == "Sydney"
  elements.sydney_hub.click()

elsif hub == "Zurich"
  elements.zurich_hub.click()
end


end

And('I select a product type {string} for that {string} and place a {string} market order for a quantity of {int}') do |product, hub, direction, quantity|
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

#
#
#
#

And(
  'I place a {string} limit order in the selected contract for a quantity of {int} '\
  'at a price {int} away from the top of the depth'
) do |direction, quantity, distance|
  elements = TradePage.new

  if direction == 'buy'
    elements.buy_button.click
  else
    elements.sell_button.click
  end

  # Animations are the worst, this sleep awaits the panel to pop completely
  sleep 1

  elements.limit_order_button.click
  elements.order_quantity_control.set(quantity)
  order_price = elements.set_order_price(direction, distance)
  elements.order_price_control.set(order_price)
  elements.review_order_button.click
  elements.submit_order_button.click
end

And(
  'I validate the matched order in the database '\
  'with order details {int}, {string}, {int}, {string} for the user {string}'
) do |contract_id, direction, quantity, order_type, user_set|
  user = YamlLoader.user_info(user_set)
  username = user['username']

  # Give the immediate settlement service 2 seconds to create trade transactions for the order
  sleep 2

  account_uuid = Helper::Account.find_account_uuid(username)
  order = Helper::Order.find_order(account_uuid, contract_id, direction, quantity)

  raise 'The order has not been filled' unless order.status == 'fill'

  raise 'The order was of the wrong type' unless order.orderType == order_type

  # Ensure this is the correct order by making sure it occured in the last 20 seconds
  order_created = order.createdAt.to_i
  current_time = Time.now.to_i

  unless order_created.between?(current_time - 20, current_time + 20)
    raise 'The orders timestamp is incorrect'
  end

  # Check the balance history to ensure holdings balance moved as expected
  order_matches = Helper::Order.find_order_matches(order.id, direction)
  trade_transactions = order_matches.map do |order_match|
    Helper::Transaction.find_trade_transaction(order_match.id, account_uuid)
  end

  recorded_quantity = trade_transactions.map(&:quantity)
  unless recorded_quantity[0] == quantity.to_i
    raise 'The quantity accumlated in the trade transactions does not equal the test condition'
  end

  trade_transactions.each do |tt|
    recorded_cost = tt.settlementAmount
    account_balance_movement = Helper::Transaction.account_balance_change_with_trade_transaction(
      tt.id,
      account_uuid,
      direction,
      2
    )

    qty = tt.quantity
    holdings_balance_movement = Helper::Transaction.holdings_balance_change_with_trade_transaction(
      tt.id,
      account_uuid,
      direction,
      contract_id
    )

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

And(
  'I validate the open order in the database '\
  'with order details {int}, {string}, {int}, {string} for the user {string} and order validity {string}'
) do |contract_id, direction, quantity, order_type, user_set, order_validity |
  user = YamlLoader.user_info(user_set)
  username = user['username']

  # Give the immediate settlement service 2 seconds to create trade transactions for the order
  sleep 2

  account_uuid = Helper::Account.find_account_uuid(username)
  order = Helper::Order.find_order(account_uuid, contract_id, direction, quantity)

  raise 'The order is not open' unless order.status == 'submit'
  raise 'The order was of the wrong type' unless order.orderType == order_type
  raise 'The order was of the wrong validity' unless order.validity == order_validity

  # Ensure this is the correct order by making sure it occured in the last 20 seconds
  order_created = order.createdAt.to_i
  current_time = Time.now.to_i

  unless order_created.between?(current_time - 20, current_time + 20)
    raise 'The orders timestamp is incorrect'
  end
end
