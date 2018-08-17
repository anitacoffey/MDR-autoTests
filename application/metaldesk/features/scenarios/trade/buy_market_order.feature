@fn_critical @tradescreen @7000 @market @buy @abx_integration @permissions @trade_behaviour
Feature: As a MetalDesk user, I should be able to create a Buy Market Order.

  Scenario Outline: To verify that all users can create a buy market order and that exchange balances update as expected
    Then I login with username and password in the "<data_set>"
    And I select a contract in "<hub>" and metal type "<metal>" for a "<direction>" order
    And I select a product type "<product>" and place a "<direction>" market order
    And I set a quantity of <quantity>
    And I validate the matched order in the database with order details <contract_id>, "<direction>", <quantity>, "<order_type>" for the user "<data_set>"
    And I exit the browser

    @pc
    Examples: PC
      | data_set | hub      | product         | metal | contract_id | direction | quantity | order_type |
      | PC1      | Brisbane | 10 oz Swiss Bar | gold  | 233         | buy       | 3        | market     |
