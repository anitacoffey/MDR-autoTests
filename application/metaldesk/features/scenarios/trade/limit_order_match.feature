@fn_critical @tradescreen @6007 @limit @trade_behaviour
Feature: As a MetalDesk user, I should be able to create a Limit Order.

  Scenario Outline: To verify that all users can create a limit order and that results in a match
    Then I login with username and password in the "<data_set>"
    And I select "<mode>" from the trade panel
    And I select a contract in "<hub>" of product type "<product>" and metal type "<metal>"
    And I place a "<direction>" limit order in the selected contract for a quantity of <quantity> at a price <distance> away from the top of the depth
    And I validate the matched order in the database with order details <contract_id>, "<direction>", <quantity>, "<order_type>" for the user "<data_set>"
    And I exit the browser

    @pc
    Examples: PC
      | data_set | mode | hub | product | metal | contract_id | direction | quantity | order_type | distance |
      | PC6_TestData1 | market | Brisbane | 10 oz Swiss Bar | gold | 233 | buy | 3 | limit | -50 |

    @pb
    Examples: PB
      | data_set | mode | hub | product | metal | contract_id | direction | quantity | order_type | distance |
      | PB3_TestData1 | market | Sydney | 1 oz Pool | silver | 206 | buy | 5 | limit | -2 |
      | PB3_TestData1 | market | Brisbane | 10 oz Swiss Bar | gold | 233 | sell | 2 | limit | -50 |