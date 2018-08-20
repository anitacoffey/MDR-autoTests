####################
# Step Definitions #
####################
And(
  'I select a metal type {string}'
  ) do |metal|
  elements = TradePage.new

  if metal == 'gold'
    metal_selector = elements.Trade_Gold
  elsif metal == 'silver'
    metal_selector = elements.Trade_Silver
  elsif metal == 'platinum'
    metal_selector = elements.Trade_Platinum
end
metal_selector.click()
end

And(
  'I select a contract in {string}'
) do |hub|
  elements = TradePage.new

  if hub == 'Dubai'
    hub_selector = elements.dubai_hub
  elsif hub == 'Hong Kong'
    hub_selector = elements.hongKong_hub
  elsif hub == 'New York'
    hub_selector = elements.newYork_hub
  elsif hub == 'Singapore'
    hub_selector = elements.singapore_hub
  elsif hub == 'London'
    hub_selector = elements.london_hub
  elsif hub == 'Sydney'
    hub_selector = elements.sydney_hub
  elsif hub == 'Zurich'
    hub_selector = elements.zurich_hub
end
hub_selector.click()
end

# And('I select a contract in {string} and metal type {string}') do |hub, metal, direction, product|
#   elements = TradePage.new

#   if metal == 'gold'
#     elements.Trade_Gold.click()
#     if hub == 'Dubai'
#       elements.dubai_hub.click()
#     if direction == 'buy' && product == '1 kg Bar 995'
#       elements.buy_kg995_Gold_Dubai.click()
#     elsif direction == 'sell' && product == 'Wholesale AAU 10 kg'
#       elements.sell_wholesale_Gold_Dubai.click()
#   elsif hub == 'Hong Kong'
#       elements.hongKong_hub.click()
#     if direction == 'buy' && product == 'Gold 10 oz Swiss'
#       elements.buy_Swiss_10oz_Gold_HongKong.click()
#     elsif direction == 'sell' && product == 'Gold 100g Swiss'
#       elements.sell_Swiss_100g_Gold_HongKong.click()
#   end

#   if metal == 'silver'
#     elements.Trade_Silver.click()
#     if hub == 'New York'
#       elements.newYork_hub.click()
#     if direction == 'buy' && product == 'Silver 1 kg bar'
#       elements.buy_1kg_Silver_NewYork.click()
#     elsif direction == 'sell' && product == 'Silver 100 oz Bar'
#       elements.sell_100oz_Silver_NewYork.click()
#     if hub == 'Singapore'
#       elements.singapore_hub.click()
#     if direction == 'sell' && product == 'Wholesale AAG 25,000 oz'
#        elements.buy_Wholesale_Silver_Singapore.click()
#   end

#   if metal == 'platinum'
#     elements.Trade_Platinum.click()
#     if hub == 'London'
#       elements.london_hub.click()
#       if direction == 'buy' && product == 'Platinum 1kg Bar'
#       elements.buy_kg_Platinum_London.click()
#     if hub == 'Sydney'
#       elements.sydney_hub.click()
#       if direction == 'sell' && product == 'Platinum 1kg Bar'
#       elements.sell_kg_Platinum_Sydney.click()
#     if hub == 'Zurich'
#       elements.zurich_hub.click()
#       if direction == 'buy' && product == 'Platinum 1kg Bar'
#       elements.buy_kg_Platinum_Zurich.click()
#  end
# end

# And('I select a product type {string} and place a {string} market order') do |product, direction|
#   elements = TradePage.new

#   if direction == 'buy' && product == '1 kg Bar 995'
#     elements.buy_kg995_Gold_Dubai.click()
#   elsif direction == 'sell' && product == 'Wholesale AAU 10 kg'
#     elements.sell_wholesale_Gold_Dubai.click()
#     elsif direction == 'buy' && product == 'Gold 10 oz Swiss'
#       elements.buy_Swiss_10oz_Gold_HongKong.click()
#     elsif direction == 'sell' && product == 'Gold 100g Swiss'
#       elements.sell_Swiss_100g_Gold_HongKong.click()
#     elsif direction == 'buy' && product == 'Silver 1 kg bar'
#       elements.buy_1kg_Silver_NewYork.click()
#     elsif direction == 'sell' && product == 'Silver 100 oz Bar'
#       elements.sell_100oz_Silver_NewYork.click()
#     elsif direction == 'sell' && product == 'Wholesale AAG 25,000 oz'
#        elements.buy_Wholesale_Silver_Singapore.click()
#     elsif direction == 'buy' && product == 'Platinum 1kg Bar'
#       elements.buy_kg_Platinum_London.click()
#     elsif direction == 'sell' && product == 'Platinum 1kg Bar'
#       elements.sell_kg_Platinum_Sydney.click()
#     elsif direction == 'buy' && product == 'Platinum 1kg Bar' #???
#       elements.buy_kg_Platinum_Zurich.click()
# end

And('I place a {string} market order for that {string}') do |direction, hub|
  elements = TradePage.new

  if direction == 'buy' && hub == 'Dubai'
    trade_metal = elements.buy_Gold_Dubai
  elsif direction == 'sell' && hub == 'Dubai'
    trade_metal = elements.sell_Gold_Dubai
    elsif direction == 'buy' && hub == 'Hong Kong'
      trade_metal = elements.buy_Gold_HongKong
    elsif direction == 'sell' && hub == 'Hong Kong'
      trade_metal = elements.sell_Gold_HongKong
    elsif direction == 'buy' && hub == 'New York'
      trade_metal = elements.buy_Silver_NewYork
    elsif direction == 'sell' && hub == 'New York'
      trade_metal = elements.sell_Silver_NewYork
    elsif direction == 'buy' && hub == 'Singapore'
      trade_metal = elements.buy_Silver_Singapore
    elsif direction == 'sell' && hub == 'Singapore'
      trade_metal = elements.sell_Silver_Singapore
    elsif direction == 'buy' && hub == 'London'
      trade_metal = elements.buy_latinum_London
    elsif direction == 'sell' && hub == 'London'
      trade_metal = elements.sell_Platinum_London
    elsif direction == 'buy' && hub == 'Sydney'
      trade_metal = elements.buy_Platinum_Sydney
    elsif direction == 'sell' && hub == 'Sydney'
      trade_metal = elements.sell_Platinum_Sydney
    elsif direction == 'buy' && hub == 'Zuirch'
      trade_metal = elements.buy_kg_Platinum_Zurich
    elsif direction == 'sell' && hub == 'Zuirch'
      trade_metal = elements.sell_Platinum_Zurich
end
trade_metal.click()
end

And(
  'I set a quantity of {int}'
) do |quantity|
elements = TradePage.new
elements.order_quantity_control.set(quantity)
elements.confirm_button.click()
end

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
