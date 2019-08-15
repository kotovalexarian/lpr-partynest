Feature: Account
  Scenario: of a user
    Given there is a usual account with the following data:
      | nickname      | kotovalexarian |
      | public_name   | Alex Kotov     |
      | biography     | Hi there :)    |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I do not see text "Администратор"
    And I see text "Hi there :)"
    And I see text "Не относится к партии"

  Scenario: of a superuser
    Given there is a superuser account with the following data:
      | nickname      | kotovalexarian |
      | public_name   | Alex Kotov     |
      | biography     | Hi there :)    |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Администратор"
    And I see text "Hi there :)"
    And I see text "Не относится к партии"

  Scenario: of a supporter
    Given there is a supporter account with the following data:
      | nickname        | kotovalexarian |
      | public_name     | Alex Kotov     |
      | biography       | Hi there :)    |
      | federal_subject | Москва         |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
    And I see text "Сторонник партии"
    And I see text "Москва"

  Scenario: of a member
    Given there is a member account with the following data:
      | nickname        | kotovalexarian |
      | public_name     | Alex Kotov     |
      | biography       | Hi there :)    |
      | federal_subject | Москва         |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
    And I see text "Член партии"
    And I see text "Москва"

  Scenario: of an excluded member
    Given there is an excluded member account with the following data:
      | nickname        | kotovalexarian |
      | public_name     | Alex Kotov     |
      | biography       | Hi there :)    |
      | federal_subject | Москва         |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
    And I see text "Исключён из партии"
    And I see text "Москва"

  Scenario: of a federal manager
    Given there is a federal manager account with the following data:
      | nickname        | kotovalexarian |
      | public_name     | Alex Kotov     |
      | biography       | Hi there :)    |
      | federal_subject | Москва         |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
    And I see text "Член партии"
    And I see text "Член ФК"
    And I see text "Москва"
