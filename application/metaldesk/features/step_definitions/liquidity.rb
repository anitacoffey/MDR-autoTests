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
