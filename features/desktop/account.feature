Feature: Account
  Scenario:
    Given there is an account with the following data:
      | username      | kotovalexarian |
      | public_name   | Alex Kotov     |
      | biography     | Hi there :)    |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
