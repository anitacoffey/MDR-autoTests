@metaldesk @fn_critical @liquidity_page @abx-2329 @abx-3003
Feature: A liquidity provider can place, cancel and update spread orders on the liquidity page

Scenario Outline: create and verify a new order
  Given I am in the MetalDesk Page
  And I login with username and password in the "<data_set>"
  And I navigate to the Liquidity screen
  And I select a product
  When I place a <type> <unit> order
  Then The <type> <unit> order is visible
  And I exit the browser
  @mm
  Examples:MM
    |type  |unit    |data_set     |
    |bid   |percent |PB2_TestData1|
    |offer |value   |PB2_TestData1|

Scenario Outline: create and cancel a new order and verify the order has been cancelled
  Given I am in the MetalDesk Page
  And I login with username and password in the "<data_set>"
  And I navigate to the Liquidity screen
  And I select a product
  When I place and cancel a <type> <unit> order
  Then The <type> <unit> order is not visible
  And I exit the browser
  @mm
  Examples:MM
    |type  |unit    |data_set     |
    |bid   |percent |PB2_TestData1|
    |offer |value   |PB2_TestData1|

Scenario Outline: create and update a new order and verify the order has been updated
  Given I am in the MetalDesk Page
  And I login with username and password in the "<data_set>"
  And I navigate to the Liquidity screen
  And I select a product
  When I place and update a <type> <unit> order
  Then The <type> <unit> order is updated
  And I exit the browser
  @mm
  Examples:MM
    |type  |unit    |data_set     |
    |offer |percent |PB2_TestData1|
    |bid   |value   |PB2_TestData1|

Scenario Outline: create and verify a new order with active hours
  Given I am in the MetalDesk Page
  And I login with username and password in the "<data_set>"
  And I navigate to the Liquidity screen
  And I select a product
  When I place a <type> <unit> order in active hours
  Then The <type> <unit> order is visible in active hours
  And I exit the browser
  @mm
  Examples:MM
    |type  |unit    |data_set     |
    |bid   |value   |PB2_TestData1|
    |offer |percent |PB2_TestData1|

Scenario Outline: create and cancel a new order with active hours and verify the order has been cancelled
  Given I am in the MetalDesk Page
  And I login with username and password in the "<data_set>"
  And I navigate to the Liquidity screen
  And I select a product
  When I place and cancel a <type> <unit> order in active hours
  Then The <type> <unit> order is not visible in active hours
  And I exit the browser
  @mm
  Examples:MM
    |type  |unit    |data_set     |
    |bid   |percent |PB2_TestData1|
    |offer |value   |PB2_TestData1|

Scenario Outline: kill all open liquidity orders
  Given I am in the MetalDesk Page
  And I login with username and password in the "<data_set>"
  And I navigate to the Liquidity screen
  And I place multiple spread orders
  When I click the kill all orders button
  Then There are no more orders visible
  And I exit the browser
  @mm
  Examples:MM
    |data_set     |
    |PB4_TestData1|
