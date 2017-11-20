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

Given('I select a contract on the liquidity page in {string} of product type {string} and metal type {string}') do |hub, product, metal|
  page_elements = LiquidityPage.new
  page_elements.filter_hub(hub)
  page_elements.filter_metal(metal)
  page_elements.select_product(product)
end

When("I place an order of type {string}, with unit as {string}, a quantity of {int} and value of {int}") do |type, unit, qty, value|
  place_order(type, unit, qty, value)
end

Then("The spread order exists in the database for contract_id {int} with a quantity of {int}, value of {int} and unit of {string} for the user {string}") do |int, int2, int3, string, string2|
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
