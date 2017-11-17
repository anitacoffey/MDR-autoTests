@metaldesk @setup @liquidity_page
Feature: As an LP, provide liquidity for all silver contracts

  Scenario Outline: provide liquidity of quantity 100 to all silver contracts
    And I login with username and password in the "<data_set>"
    And I navigate to the Liquidity screen as "<data_set>"
    And I provide liquidity for all silver contracts
    And I exit the browser

    @mm
    Examples:MM
      |data_set     |
      |PB2_TestData1|
      |PB4_TestData1|
