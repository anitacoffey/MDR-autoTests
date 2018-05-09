@fn_critical @tradescreen @6011 @market @buy @abx_integration @permissions @trade_behaviour
Feature: As a MetalDesk user, I should be able to create a Buy limit Order for a specific Date/Time.

  Scenario Outline: To verify that all users can create a buy limit order for a Date/Time and that exchange balances update as expected
    Then I login with username and password in the "<data_set>"
    And I select "<mode>" from the trade panel
    And I select a contract in "<hub>" of product type "<product>" and metal type "<metal>"
    And I place a "<direction>" limit order in the selected contract for a quantity of <quantity> at a price <distance> away from the top of the depth to be placed for a specific date and time
    And I validate the open order in the database with order details <contract_id>, "<direction>", <quantity>, "<order_type>" for the user "<data_set>"
    And I exit the browser

    @pc
    Examples: PC
      | data_set | mode | hub | product | metal | contract_id | direction | quantity | order_type | distance |
      | PC6_TestData1 | market | Brisbane | 10 oz Swiss Bar | gold | 233 | buy | 3 | limit | 100 |
 
    @pb
    Examples: PB
      | data_set | mode | hub | product | metal | contract_id | direction | quantity | order_type | distance |
      | PB3_TestData1 | market | Sydney | 1 oz Pool | silver | 206 | buy | 5 | limit | 2 |
      | PB3_TestData1 | market | Brisbane | 10 oz Swiss Bar | gold | 233 | sell | 2 | limit | 100 |
