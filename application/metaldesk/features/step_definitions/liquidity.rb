####################
# Step Definitions #
####################

# Notes: There is still some work to be done with these step definitions.
# The contract selections are still hard coded. It would be nice for that to
# become parameterised
And('I navigate to the Liquidity screen as {string}') do |user_data|
  user = YamlLoader.user_info(user_data)

  if user['accounttype'] != 'MM' && $browser.text.downcase.include?('liquidity')
    raise "Liquidity tab should not exist for #{user['username']}"
  end

  Watir::Wait.until(timeout: 5) { $browser.span(text: 'Liquidity').exists? }
  NavigationPage.new.to_liquidity_page
  Watir::Wait.until(timeout: 5) { $browser.h1(text: 'Liquidity').exists? }
end

Given(
  'I select a contract on the liquidity page in {string} of product type {string} and metal type {string}'
) do |hub, product, metal|
  page_elements = LiquidityPage.new
  page_elements.filter_hub(hub)
  page_elements.filter_metal(metal)
  page_elements.select_product(product)
end

When(
  'I place a spread order of type {string}, with unit as {string}, a quantity of {int} and value of {int}'
) do |type, unit, qty, value|
  place_order(type, unit, qty, value)
end

When(
  'I place an active hours spread order of type {string}, with unit as {string}, a quantity of {int} and value of {int}'
) do |type, unit, qty, value|
  place_active_order(type, unit, qty, value)
end

Then(
  'The spread order exists in the database for contract_id {int} with type {string}, a quantity of {int}, '\
  'value of {int} and unit of {string} for the user {string}'
) do |contract_id, type, qty, value, unit, user_set|
  user = YamlLoader.user_info(user_set)
  username = user['username']

  direction = type == 'bid' ? 'buy' : 'sell'

  account_uuid = Helper::Account::find_account_uuid(username)
  order = Helper::Order::find_order(account_uuid, contract_id, direction, qty)

  raise 'The order does not exist' if !order
  raise 'The order should be open' if order[:status] != 'submit'

  spread_order = Db::AbxModules::SpreadOrder.find_by_id(order[:spreadOrderId])

  open_times = spread_order[:openTime] == nil && spread_order[:closeTime] == nil
  spread_value = spread_order[:spreadValue].to_f == value.to_f
  spread_type = spread_order[:spreadType] == unit
  conditional = open_times && spread_value && spread_type

  raise 'The placed spread order does not have the expected properties' if !conditional
end

Then(
  'The active spread order exists in the database for contract_id {int} with type {string}, a quantity of {int}, '\
  'value of {int} and unit of {string} for the user {string}'
) do |contract_id, type, qty, value, unit, user_set|
  user = YamlLoader.user_info(user_set)
  username = user['username']

  direction = type == 'bid' ? 'buy' : 'sell'

  account_uuid = Helper::Account::find_account_uuid(username)
  order = Helper::Order::find_order(account_uuid, contract_id, direction, qty)

  raise 'The order does not exist' if !order
  raise 'The order should be open' if order[:status] != 'submit'

  spread_order = Db::AbxModules::SpreadOrder.find_by_id(order[:spreadOrderId])

  open_times = spread_order[:openTime] != nil && spread_order[:closeTime] != nil
  spread_value = spread_order[:spreadValue].to_f == value.to_f
  spread_type = spread_order[:spreadType] == unit
  conditional = open_times && spread_value && spread_type

  raise 'The placed spread order does not have the expected properties' if !conditional
end

Then('I map the current state of the page for type {string}') do |type|
  @before_state = read_depth_state(type)
end

Then(
  'The spread order exists on the page with type {string}, a quantity of {int}, '\
  'value of {int} and unit of {string}'
) do |type, qty, value, unit|
  sleep 2
  after_state = read_depth_state(type)

  spread_assignment = determine_display_unit(unit, value)

  order_with_properties_before = @before_state.select { |s| s[:spread] == spread_assignment && s[:qty] == qty }

  if order_with_properties_before.length > 0
    original_count = order_with_properties_before[0][:orders]
    new_count = after_state.select { |s| s[:spread] == spread_assignment && s[:qty] == qty }[0][:orders]

    unless original_count + 1 == new_count
      raise 'The new order is not reflected in the display'
    end
  else
    new_count = after_state.select { |s| s[:spread] == spread_assignment && s[:qty] == qty }[0][:orders]

    unless new_count == 1
      raise 'The new order is not reflected in the display'
    end
  end
end

When(
  'I cancel a spread order of type {string}, with unit as {string}, a quantity of {int} and value of {int}'
) do |type, unit, qty, value|
  cancel_order(type, unit, qty, value)
end

Then(
  'The spread order is cancelled in the database for contract_id {int} with type '\
  '{string}, a quantity of {int}, value of {int} and unit of {string} for the user {string}'
) do |contract_id, type, qty, value, unit, user_set|
  orders = Helper::Order.find_orders_by_id(@spread_order_ids_to_be_cancelled)

  orders.each do |o|
    raise 'Order not cancelled' if o[:status] != 'cancel'
  end
end

Then(
  'The spread order does not exist on the page with type {string}, a quantity of {int}, '\
  'value of {int} and unit of {string}'
) do |type, qty, value, unit|
  spread_assignment = determine_display_unit(unit, value)
  page_state_after_cancellation = read_depth_state(type)
  orders_that_were_cancelled = page_state_after_cancellation.select { |s| s[:spread] == spread_assignment && s[:qty] == qty }
  raise 'Orders not removed from page' if orders_that_were_cancelled.length > 0
end

When(
  'I update a spread order of type {string}, with unit as {string}, a quantity of {int}, '\
  'an updated quantity of {int}, a value of {int} and an updated value of {int}'
) do |type, unit, quantity, updated_quantity, value, updated_value|
  update_order(type, unit, quantity, value, updated_quantity, updated_value)
end

When('I click the kill all orders button') do
  page_elements = LiquidityPage.new
  page_elements.kill_all_btn.click
  page_elements.cancel_below_spread_orders_btn.wait_until_present
  page_elements.cancel_below_spread_orders_btn.click
  page_elements.cancellation_complete.wait_until_present
end

Then('All spread orders for the account are cancelled as {string}') do |user_set|
  user = YamlLoader.user_info(user_set)
  username = user['username']
  account_uuid = Helper::Account::find_account_uuid(username)

  orders = Db::AbxModules::Order.where(orderType: 'spread', accountId: account_uuid)

  orders.each do |o|
    raise 'Order is not cancelled' if o[:status] != 'cancel'
  end
end

##################
# Common Methods #
##################
def determine_display_unit(unit, value)
  unit == 'percent' ? "#{value}%" : "$ #{value}"
end

def read_depth_state(type)
  page_elements = LiquidityPage.new
  spread_orders = page_elements.depth_collection(type)
  spread_orders.map do |so|
    {
      qty: so.small(text: 'Qty').parent.parent.tds[1].text.to_i,
      spread: so.small(text: 'Spread').parent.parent.tds[1].text,
      orders: so.small(text: 'Orders').parent.parent.tds[1].text.to_i,
      active: so.small(text: 'Active').parent.parent.tds[1].text,
    }
  end
end

def find_spread_in_order_list(type, qty, display_unit)
  page_elements = LiquidityPage.new
  spread_orders = page_elements.depth_collection(type)
  target_orders = spread_orders.select do |so|
    qty_is_correct = so.small(text: 'Qty').parent.parent.tds[1].text.to_i == qty
    spread_unit_is_correct = so.small(text: 'Spread').parent.parent.tds[1].text
    qty_is_correct && spread_unit_is_correct
  end

  target_orders[0]
end

def cancel_order(type, unit, quantity, value)
  Guard.check_parameters([type, unit, quantity, value])
  page_elements = LiquidityPage.new

  display_unit = determine_display_unit(unit, value)
  spread_order_element = find_spread_in_order_list(type, quantity, display_unit)
  page_elements.cancel_btn(spread_order_element).click

  page_elements.cancel_below_spread_orders_btn.wait_until_present

  @spread_order_ids_to_be_cancelled = page_elements.confirmation_ids
  page_elements.cancel_below_spread_orders_btn.click

  page_elements.cancellation_complete.wait_until_present
end

def update_order(type, unit, original_quantity, original_value, update_quantity, update_value)
  page_elements = LiquidityPage.new

  display_unit = determine_display_unit(unit, original_value)
  spread_order_element = find_spread_in_order_list(type, original_quantity, display_unit)
  page_elements.update_btn(spread_order_element).click

  page_elements.quantity_input.to_subtype.clear
  page_elements.quantity_input.send_keys(update_quantity)
  page_elements.value_input.to_subtype.clear
  page_elements.value_input.send_keys(update_value)
  page_elements.review_update_btn.click

  page_elements.confirm_update_btn.wait_until_present
  page_elements.confirm_update_btn.click
  page_elements.return_to_order_screen_btn.wait_until_present
  page_elements.return_to_order_screen_btn.click
end

def place_order(type, unit, quantity, value)
  Guard.check_parameters([type, unit, quantity, value])
  page_elements = LiquidityPage.new

  # input to form
  input_place_order(type, unit, quantity, value)
  page_elements.review_order_btn.click

  # confirm order placement
  confirm_order
end

def place_active_order(type, unit, quantity, value)
  Guard.check_parameters([type, unit, quantity, value])
  page_elements = LiquidityPage.new

  # input to form
  input_place_order(type, unit, quantity, value)
  page_elements.active_hours_btn.click
  input_open_close_times

  page_elements.review_order_btn.click

  # confirm order placement
  confirm_order
end

def confirm_order
  page_elements = LiquidityPage.new
  page_elements.confirm_placement_btn.wait_until_present
  page_elements.confirm_placement_btn.click
  page_elements.return_to_order_screen_btn.wait_until_present
  page_elements.return_to_order_screen_btn.click
end

def input_place_order(type, unit, qty, val)
  page_elements = LiquidityPage.new
  offer_click_or_not(type)
  value_click_or_not(unit)
  page_elements.quantity_input.to_subtype.clear
  page_elements.quantity_input.send_keys(qty)
  page_elements.value_input.to_subtype.clear
  page_elements.value_input.send_keys(val)
end

def offer_click_or_not(type)
  return if type != 'offer'

  page_elements = LiquidityPage.new
  page_elements.offer_btn.wait_until_present
  page_elements.offer_btn.click
end

def value_click_or_not(unit)
  page_elements = LiquidityPage.new

  if unit == 'value'
    page_elements.value_btn.wait_until_present
    page_elements.value_btn.click
  else
    page_elements.percent_btn.wait_until_present
    page_elements.percent_btn.click
  end
end

def input_open_close_times
  page_elements = LiquidityPage.new
  page_elements.open_time.wait_until_present
  page_elements.open_time.click
  page_elements.open_time_value.wait_until_present
  page_elements.open_time_value.click

  page_elements.close_time.wait_until_present
  page_elements.close_time.click
  page_elements.close_time_value.wait_until_present
  page_elements.close_time_value.click

  page_elements.time_zone.wait_until_present
  page_elements.time_zone.click
  page_elements.time_zone_value.wait_until_present
  page_elements.time_zone_value.click
end
