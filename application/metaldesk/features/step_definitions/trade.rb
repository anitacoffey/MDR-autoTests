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





And('I place a {string} market order in the selected contract for a quantity of {int} on behalf of a client {string}') do |direction, quantity, client_data_set|
  elements = TradePage.new

  if direction == 'buy'
    elements.buy_button.click
  else
    elements.sell_button.click
  end

  select_clients = YamlLoader.user_info(client_data_set) 
  client_hin = select_clients['hin']
  client_data_set = client_hin
  

  # Animations are the worst, this sleep awaits the panel to pop completely
  sleep 1

  elements.market_order_button.click
  elements.select_client_filter(client_data_set)
  elements.order_quantity_control.set(quantity)
  elements.review_order_button.click
  elements.submit_order_button.click
end







And('I place a {string} limit order in the selected contract for a quantity of {int} at a price {int} away from '\
  'the top of the depth on behalf of a client {string}') do |direction, quantity, distance, client_data_set|
  elements = TradePage.new

  if direction == 'buy'
    elements.buy_button.click
  else
    elements.sell_button.click
  end

  select_clients = YamlLoader.user_info(client_data_set) 
  client_hin = select_clients['hin']
  client_data_set = client_hin

  # Animations are the worst, this sleep awaits the panel to pop completely
  sleep 1

  elements.limit_order_button.click
  elements.select_client_filter(client_data_set)
  elements.order_quantity_control.set(quantity)

  top_of_depth = 0
  if direction == 'buy'
    top_of_depth = elements.top_buy_depth
  else
    top_of_depth = elements.top_sell_depth
  end

  order_price = direction == 'buy' ? top_of_depth - distance : top_of_depth + distance
  elements.order_price_control.set(order_price)
  elements.review_order_button.click
  elements.submit_order_button.click
end



And('I place a {string} limit order in the selected contract for a quantity of {int} at a price {int} away from the top of the depth') do |direction, quantity, distance|
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

  top_of_depth = 0
  if direction == 'buy'
    top_of_depth = elements.top_buy_depth
  else
    top_of_depth = elements.top_sell_depth
  end

  order_price = direction == 'buy' ? top_of_depth - distance : top_of_depth + distance
  elements.order_price_control.set(order_price)
  elements.review_order_button.click
  elements.submit_order_button.click
end

And('I place a {string} limit order in the selected contract for a quantity of {int} to be placed for a specific date and time') do |direction, quantity|
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

  elements.order_quantity_control.set(quantity)
  elements.select_date_time
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
  'with order details {int}, {string}, {int}, {string} for the user {string}'
) do |contract_id, direction, quantity, order_type, user_set|
  user = YamlLoader.user_info(user_set)
  username = user['username']

  # Give the immediate settlement service 2 seconds to create trade transactions for the order
  sleep 2

  account_uuid = Helper::Account.find_account_uuid(username)
  order = Helper::Order.find_order(account_uuid, contract_id, direction, quantity)

  byebug
  raise 'The order is not open' unless order.status == 'submit'
  raise 'The order was of the wrong type' unless order.orderType == order_type

  # Ensure this is the correct order by making sure it occured in the last 20 seconds
  order_created = order.createdAt.to_i
  current_time = Time.now.to_i

  unless order_created.between?(current_time - 20, current_time + 20)
    raise 'The orders timestamp is incorrect'
  end
end













