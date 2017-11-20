@fn_critical @tradescreen @6005 @market @buy @abx_integration @permissions @trade_behaviour
Feature: As a MetalDesk user, I should be able to create a Buy Market Order.

  Scenario Outline: To verify that all users can create a buy market order and that exchange balances update as expected

    Given I am in the MetalDesk Page
    Then I login with username and password in the "<data_set>"
    And I select "<mode>" from the trade panel
    And I select a contract in "<hub>" of product type "<product>" and metal type "<metal>"
    And I place a "<direction>" market order in the selected contract for a quantity of "<quantity>"
    And I validate the matched order in the database with order details "<contract_id>", "<direction>", "<quantity>", "<order_type>" for the user "<data_set>"
    And I exit the browser

  @pc
    Examples: PC
      |data_set|mode|hub|product|metal|contract_id|direction|quantity|order_type|
      |PC6_TestData1|market|Brisbane|1 kg Bar|gold|8|buy|3|market|

  @pb
    Examples: PB
      |data_set|mode|hub|product|metal|contract_id|direction|quantity|order_type|
      |PB3_TestData1|market|Sydney|1 oz Pool|silver|206|buy|5|market|
      |PB3_TestData1|market|Brisbane|10 oz Swiss Bar|gold|233|sell|2|market|
