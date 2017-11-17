@metaldesk @fn_high @liquidity_page 
Feature: As an LP, when I create a spread order, it becomes an open order, verify in Trade -> Open Orders and in Reports -> Orders -> Open

Scenario Outline: create and verify a new spread order
  Given I am in the MetalDesk Page
  And I login with username and password in the "<data_set>"
  And I navigate to the Liquidity screen
  And I filter by a random hub on the Liquidity screen
  And I select a product
  When I place a <type> <unit> order
  Then The <type> <unit> order is visible
  And I navigate to the Trade screen
  And I verify the open orders section update for "<data_set>"
  And I navigate to Reports screen
  And I select the Orders tab
  And I select the client in the orders tab for "<data_set>"
  And I verify the orders section update in Reports for "<data_set>"
  And I exit the browser
  @mm
  Examples:MM
    |type  |unit    |data_set     |
    |bid   |percent |PB2_TestData1|
    |offer |value   |PB2_TestData1|
