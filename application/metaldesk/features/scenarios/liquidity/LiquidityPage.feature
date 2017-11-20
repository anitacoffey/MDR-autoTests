@metaldesk @fn_critical @liquidity_page @abx-2329 @abx-3003
Feature: A liquidity provider can place, cancel and update spread orders on the liquidity page

  Scenario Outline: create a spread order
    Given I login with username and password in the "<data_set>"
    Then I navigate to the Liquidity screen as "<data_set>"
    And I select a contract on the liquidity page in "<hub>" of product type "<product>" and metal type "<metal>"
    And I map the current state of the page for type "<type>"
    When I place a spread order of type "<type>", with unit as "<unit>", a quantity of <qty> and value of <value>
    Then The spread order exists in the database for contract_id <contract_id> with type "<type>", a quantity of <qty>, value of <value> and unit of "<unit>" for the user "<data_set>"
    And The spread order exists on the page with type "<type>", a quantity of <qty>, value of <value> and unit of "<unit>" for the user "<data_set>"
    Then I exit the browser

    @mm
    Examples: MM
      | type | unit | data_set | qty | value | hub | product | metal | contract_id |
      | bid | percent | PB2_TestData1 | 2 | 2 | Brisbane | Canadian Maple | Gold | 28 |
      | offer | value | PB2_TestData1 | 3 | -5 | Sydney | American Eagle | Silver | 112 |
