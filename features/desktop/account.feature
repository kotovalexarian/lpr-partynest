Feature: Account
  Scenario: of a user
    Given there is a usual account with the following data:
      | username      | kotovalexarian |
      | public_name   | Alex Kotov     |
      | biography     | Hi there :)    |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"

  Scenario: of a supporter
    Given there is a supporter account with the following data:
      | username      | kotovalexarian |
      | public_name   | Alex Kotov     |
      | biography     | Hi there :)    |
      | country_state | Москва         |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"

  Scenario: of a member
    Given there is a member account with the following data:
      | username      | kotovalexarian |
      | public_name   | Alex Kotov     |
      | biography     | Hi there :)    |
      | country_state | Москва         |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
