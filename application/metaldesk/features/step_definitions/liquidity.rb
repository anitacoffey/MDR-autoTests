####################
# Step Definitions #
####################
And('I navigate to the Liquidity screen as {string}') do |user_data|
  user = YamlLoader.user_info(user_data)

  if user['accounttype'] != 'MM' && $browser.text.downcase.include?('liquidity')
    raise "Liquidity tab should not exist for #{user['username']}"
  end

  Watir::Wait.until(timeout: 5) { $browser.span(text: 'Liquidity').exists? }
  UIElements_Main.get_navigate_elements($browser, 'LIQUIDITY')
  Watir::Wait.until(timeout: 5) { $browser.h1(text: 'Liquidity').exists? }
end

And('I filter by a random hub on the Liquidity screen') do
  index = rand(1..2)

  page_elements = LiquidityPage.new
  page_elements.hub_filter.click
  page_elements.filter_hub(0).click
  page_elements.filter_hub(index).click
end

And('I select a product') do
  index = rand(1..5)
  page_elements = LiquidityPage.new
  page_elements.select_product(index).click
end

And('I place multiple spread orders for a {int} and {int}') do |qty, value|
  [0, 1, 2].each do |product_index|
    select_product(product_index)
    place_order('bid', 'value', qty, value)
    verify_order_placed('bid', 'value', qty, value)
    place_order('offer', 'value', 'random', qty, value)
    verify_order_placed('offer', 'value', qty, -value)
  end
end

And('I determine all contracts and place spread orders for these contracts') do
  contracts = $browser.divs(id: 'autotests__liquidityPage__tradeableContract')
  contracts.each do |element|
    element.click
    place_order('bid', 'value', 100, 2)
    place_order('offer', 'value', 100, -2)
  end
end

And('I provide liquidity for all silver contracts') do
  select_metal('silver') # uncheck gold
  sleep 1 # needed
  [6, 5, 4, 3, 2, 1, 0].each do |product_index|
    select_product(product_index)
    place_order('bid', 'value', 100, 1)
    verify_order_placed('bid', 'value', 100, 1)
    place_order('offer', 'value', 100, -1)
    verify_order_placed('offer', 'value', 100, -1)
  end
  select_metal('silver') # check gold back for future tests
end

When('I click the kill all orders button') do
  page_elements = LiquidityPage.new
  page_elements.kill_all_btn.click
  page_elements.cancel_below_spread_orders_btn.wait_until_present
  page_elements.cancel_below_spread_orders_btn.click
  page_elements.cancellation_complete.wait_until_present
end

Then('There are no more orders visible') do
  [0, 1].each do |product_index|
    select_product(product_index)
    verify_no_depth('bid')
    verify_no_depth('offer')
  end
end

When('I place a {string} {string} {int} {int} order') do |type, unit, qty, value|
  place_order(type, unit, qty, value)
end

Then('The {string} {string} {int} {int} order is visible') do |type, unit, qty, value|
  verify_order_placed(type, unit, qty, value)
end

When('I place and cancel a {string} {string} {int} {int} order') do |type, unit, qty, value|
  page_elements = LiquidityPage.new
  place_order(type, unit, qty, value)

  # now cancel the above plaved order
  # find the depth
  order_type = bid_or_offer(type)
  length = find_the_depth(order_type)

  # traverse the entire depth collection to find the order qty and value you placed above
  flag = 0
  length.times do |itr|
    order_qty, order_value, order_value_unit = iterate_to_find_order(order_type, itr)
    display_unit = percent_or_value(unit)

    next if order_qty.to_i == qty && order_value.to_f == value && order_value_unit == display_unit
    flag += 1
    page_elements.cancel_btn(order_type, itr).click
    break
  end

  # confirm cancellation
  page_elements.cancel_below_spread_orders_btn.wait_until_present
  page_elements.cancel_below_spread_orders_btn.click

  # if order was found and set to be cancelled, then display success message, else raise error
  raise 'Correct order not visible' if flag != 1

  # click again on the product you're working on, so that the depth is indeed refreshed
  page_elements.select_product(5).click
end

# these are the two vars from the data grid
Then('The {string} {string} {int} {int} order is not visible') do |type, unit, qty, value|
  # traverse the entire depth collection to find the order qty and value you cancelled above
  flag = traverse_depth(type, unit, qty, value)
  # if order found, raise error, else success message
  raise 'Order cancellation not verified' if flag == 1
end

When('I place and update a {string} {string} {int} {int} order') do |type, unit, qty, value|
  page_elements = LiquidityPage.new
  place_order(type, unit, qty, value)

  # now update the above placed order
  # find the depth
  order_type = bid_or_offer(type)
  length = find_the_depth(order_type)

  # traverse the entire depth collection to find the order qty and value you placed above
  flag = 0
  length.times do |itr|
    order_qty, order_value, order_value_unit = iterate_to_find_order(order_type, itr)
    display_unit = percent_or_value(unit)

    next if order_qty.to_i == qty && order_value.to_f == value && order_value_unit == display_unit
    flag += 1
    page_elements.update_btn(order_type, itr).click
    break
  end

  # input new values and confirm update
  page_elements.review_update_btn.wait_until_present
  page_elements.value_input.to_subtype.clear
  page_elements.value_input.send_keys(update_value)
  page_elements.review_update_btn.click
  page_elements.confirm_update_btn.wait_until_present
  page_elements.confirm_update_btn.click
  page_elements.return_to_order_screen_btn.wait_until_present
  page_elements.return_to_order_screen_btn.click

  # if order was found and set to be updated, display success message, else raise error
  raise 'Correct order not visible' if flag != 1
end

Then('The $type $unit order is updated') do |type, unit, qty, value|
  # to verify order has been updated
  # find the depth
  order_type = bid_or_offer(type)
  find_the_depth(order_type)

  # traverse the entire depth collection to find the order qty and value you updated above
  flag = traverse_depth(type, unit, qty, value)

  # if order updated, then display success message, else raise error
  raise 'Order updation not verified' if flag != 1
end

When('I place a {string} {string} {int} {int} order in active hours') do |type, unit, _qty, value|
  page_elements = LiquidityPage.new

  # input to form
  input_place_order(type, unit, quantity, value)
  page_elements.active_hours_btn.click

  # input open and close times and time zone
  input_open_close_times

  # REVIEW: order
  page_elements.review_order_btn.wait_until_present
  page_elements.review_order_btn.click

  # confirm order
  confirm_order
end

Then('The {string} {string} {int} {int} order is visible in active hours') do |type, unit, qty, _value|
  page_elements = LiquidityPage.new

  # verify the active order placed
  # find the depth
  order_type = bid_or_offer(type)
  length = find_the_depth(order_type)

  # traverse the entire depth collection to find the order qty and value you placed above
  flag = 0
  length.times do |itr|
    order_qty, order_value, order_value_unit = iterate_to_find_order(order_type, itr)
    display_unit = percent_or_value(unit)
    active_value_text = page_elements.active_value(order_type, itr).text

    ts = '09:00 - 17:00 UTC+08:00'
    if order_qty.to_i == qty && order_value.to_f == value_active && order_value_unit == display_unit && active_value_text == ts
      flag += 1
      break
    end
  end

  # if order found, then display success message else raise error
  raise 'Correct order not visible' if flag != 1
end

When('I place and cancel a {string} {string} {int} {int} order in active hours') do |type, unit, _qty, value|
  page_elements = LiquidityPage.new

  # input to form
  input_place_order(type, unit, quantity, value)
  page_elements.active_hours_btn.click

  # input open and close times and time zone
  input_open_close_times

  # REVIEW: order
  page_elements.review_order_btn.wait_until_present
  page_elements.review_order_btn.click

  # confirm order
  confirm_order

  # now cancel the above plaved order
  # find the depth
  order_type = bid_or_offer(type)
  length = find_the_depth(order_type)

  # traverse the entire depth collection to find the order qty and value you placed above
  flag = 0
  length.times do |itr|
    order_qty, order_value, order_value_unit = iterate_to_find_order(order_type, itr)
    display_unit = percent_or_value(unit)
    next if order_qty.to_i == quantity && order_value.to_f == value && order_value_unit == display_unit
    flag += 1
    page_elements.cancel_btn(order_type, itr).click
    break
  end

  # confirm cancellation
  page_elements.cancel_below_spread_orders_btn.wait_until_present
  page_elements.cancel_below_spread_orders_btn.click

  # if order was found and set to be cancelled, then display success message, else raise error
  raise 'Correct order not visible' if flag != 1

  # click again on the product you're working on, so that the depth is indeed refreshed
  page_elements.select_product(5).click
end

Then('The {string} {string} {int} {int} order is not visible in active hours') do |type, unit, _qty, value|
  # to verify the order has been cancelled
  # find the depth
  order_type = bid_or_offer(type)
  find_the_depth(order_type)

  # traverse the entire depth collection to find the order qty and value you cancelled above
  flag = traverse_depth(type, unit, quantity, value)

  # if order found, raise error, else success message
  raise 'Order cancellation not verified' if flag == 1
end

##################
# Common Methods #
##################
def place_order(type, unit, quantity, value)
  Guard.check_parameters([type, unit, quantity, value])
  page_elements = LiquidityPage.new

  # input to form
  input_place_order(type, unit, quantity, value)
  page_elements.review_order_btn.click

  # confirm order placement
  confirm_order
end

def verify_order_placed(type, unit, quantity, value)
  Guard.check_parameters([type, unit, quantity, value])
  # find the depth
  order_type = bid_or_offer(type)
  length = find_the_depth(order_type)

  # traverse the entire depth collection to find the order qty and value you placed above
  flag = 0
  length.times do |itr|
    order_qty, order_value, order_value_unit = iterate_to_find_order(order_type, itr)
    display_unit = percent_or_value(unit)
    next unless order_qty.to_i == quantity && order_value.to_f == value && order_value_unit == display_unit
    flag += 1
    break
  end

  # if order found, then display success message, else raise error
  raise 'Correct order not visible' if flag != 1
end

def traverse_depth(type, unit, quantity, value)
  Guard.check_parameters([type, unit, quantity, value])

  flag = 0
  length.times do |itr|
    order_qty, order_value, order_value_unit = iterate_to_find_order(type, itr)
    display_unit = percent_or_value(unit)
    if order_qty.to_i == quantity && order_value.to_f == value && order_value_unit == display_unit
      flag += 1
      break
    end
  end

  flag
end

# helper method for buy or sell
def bid_or_offer(type)
  Guard.check_parameters([type])
  if type == 'bid'
    'buyButton'
  elsif type == 'offer'
    'sellButton'
  end
end

# helper method for % or $
def percent_or_value(unit)
  Guard.check_parameters([unit])
  if unit == 'value'
    'DOLLARS'
  elsif unit == 'percent'
    'PERCENT'
  end
end

# helper method when order is a sell order
def offer_click_or_not(type)
  Guard.check_parameters([type])
  page_elements = LiquidityPage.new

  return if type != 'offer'

  page_elements.offer_btn.wait_until_present
  page_elements.offer_btn.click
end

# helper method when order is based on $ and not %
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

# helper method to find the depth values
def iterate_to_find_order(order_type, itr)
  page_elements = LiquidityPage.new
  page_elements.depth_container.wait_until_present
  page_elements.depth_qty(order_type, itr).wait_until_present
  order_qty = page_elements.depth_qty(order_type, itr).text
  page_elements.depth_container.wait_until_present
  page_elements.depth_value(order_type, itr).wait_until_present
  if page_elements.depth_value(order_type, itr).text.include? '%'
    order_value_unit = 'PERCENT'
    order_value = page_elements.depth_value(order_type, itr).text[0..4]
  elsif page_elements.depth_value(order_type, itr).text.include? '$'
    order_value_unit = 'DOLLARS'
    order_value = page_elements.depth_value(order_type, itr).text[2..6]
  end
  [order_qty, order_value, order_value_unit]
end

# helper method to confirm order
def confirm_order
  page_elements = LiquidityPage.new
  page_elements.confirm_placement_btn.wait_until_present
  page_elements.confirm_placement_btn.click
  page_elements.return_to_order_screen_btn.wait_until_present
  page_elements.return_to_order_screen_btn.click
end

# helper method to input data for new order
def input_place_order(type, unit, qty, val)
  Guard.check_parameters([order_type])
  page_elements = LiquidityPage.new
  offer_click_or_not(type)
  value_click_or_not(unit)
  page_elements.quantity_input.to_subtype.clear
  page_elements.quantity_input.send_keys(qty)
  page_elements.value_input.to_subtype.clear
  page_elements.value_input.send_keys(val)
end

# helper method to find the depth
def find_the_depth(order_type)
  Guard.check_parameters([order_type])
  page_elements = LiquidityPage.new
  page_elements.review_order_btn.wait_until_present
  page_elements.depth_container.wait_until_present
  length = page_elements.depth_collection(order_type).length
  length
end

# helper method to input data for open and close times in order_type
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
