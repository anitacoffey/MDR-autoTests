And(/^I navigate to the Liquidity screen$/) do
  UserLiquidityHelper.navigate_liquidity
end

And (/^I filter by a random hub on the Liquidity screen$/) do
  UserLiquidityHelper.filter_hub('random')
end

And(/^I select a product$/) do
  UserLiquidityHelper.select_product('random')
end

And(/^I place multiple spread orders$/) do
  UserLiquidityHelper.place_multiple_spread_orders([0, 1])
end

And(/^I determine all contracts and place spread orders for these contracts$/) do
  UserLiquidityHelper.place_all_spread_orders()
end

And(/^I provide liquidity for all silver contracts$/) do
  UserLiquidityHelper.provide_silver_liquidity
end

When(/^I click the kill all orders button$/) do
  UserLiquidityHelper.kill_all_orders()
end

Then(/^There are no more orders visible$/) do
  UserLiquidityHelper.verify_expected_depths_are_empty([0, 1])
end

When(/^I place a (.*) (.*) order$/) do |type, unit|
  UserLiquidityHelper.place_order(type,unit,'random')
end

Then(/^The (.*) (.*) order is visible$/) do |type, unit|
  UserLiquidityHelper.verify_order_placed(type,unit)
end

When(/^I place and cancel a (.*) (.*) order$/) do |type, unit|
  UserLiquidityHelper.place_cancel_order(type, unit)
end

# these are the two vars from the data grid
Then(/^The (.*) (.*) order is not visible$/) do |type, unit|
  UserLiquidityHelper.verify_order_cancelled(type, unit)
end

When(/^I place and update a (.*) (.*) order$/) do |type, unit|
  UserLiquidityHelper.place_update_order(type, unit)
end

Then(/^The (.*) (.*) order is updated$/) do |type, unit|
  UserLiquidityHelper.verify_order_updated(type, unit)
end

When(/^I place a (.*) (.*) order in active hours$/) do |type, unit|
  UserLiquidityHelper.place_active_order(type,unit)
end

Then(/^The (.*) (.*) order is visible in active hours$/) do |type, unit|
  UserLiquidityHelper.verify_active_order_placed(type,unit)
end

When(/^I place and cancel a (.*) (.*) order in active hours$/) do |type, unit|
  UserLiquidityHelper.place_cancel_active_order(type, unit)
end

Then(/^The (.*) (.*) order is not visible in active hours$/) do |type, unit|
  UserLiquidityHelper.verify_active_order_cancelled(type, unit)
end
