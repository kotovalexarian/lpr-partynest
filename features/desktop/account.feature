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
    And I see text "Член или сторонник"
    And I see text "Сторонник"

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
    And I see text "Исключённый член"

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
    And I see text "Член или сторонник"
    And I see text "Член"

  Scenario: of a federal manager
    Given there is a member account with the following data:
      | factory         | federal_manager_person |
      | nickname        | kotovalexarian         |
      | public_name     | Alex Kotov             |
      | biography       | Hi there :)            |
      | federal_subject | Москва                 |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
    And I see text "Член или сторонник"
    And I see text "Член"
    And I see text "Член ФК"

  Scenario: of a federal supervisor
    Given there is a member account with the following data:
      | factory         | federal_supervisor_person |
      | nickname        | kotovalexarian            |
      | public_name     | Alex Kotov                |
      | biography       | Hi there :)               |
      | federal_subject | Москва                    |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
    And I see text "Член или сторонник"
    And I see text "Член"
    And I see text "Член ЦКРК"

  Scenario: of a regional manager
    Given there is a member account with the following data:
      | factory         | regional_manager_person |
      | nickname        | kotovalexarian         |
      | public_name     | Alex Kotov             |
      | biography       | Hi there :)            |
      | federal_subject | Москва                 |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
    And I see text "Член или сторонник"
    And I see text "Член"
    And I see text "Член РК РО"

  Scenario: of a regional supervisor
    Given there is a member account with the following data:
      | factory         | regional_supervisor_person |
      | nickname        | kotovalexarian            |
      | public_name     | Alex Kotov                |
      | biography       | Hi there :)               |
      | federal_subject | Москва                    |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
    And I see text "Член или сторонник"
    And I see text "Член"
    And I see text "Член РКРК"

  Scenario: of a regional secretary
    Given there is a member account with the following data:
      | factory         | regional_secretary_person |
      | nickname        | kotovalexarian            |
      | public_name     | Alex Kotov                |
      | biography       | Hi there :)               |
      | federal_subject | Москва                    |
    When I visit "/accounts/kotovalexarian"
    Then I see text "kotovalexarian"
    And I see text "Alex Kotov"
    And I see text "Hi there :)"
    And I see text "Член или сторонник"
    And I see text "Член"
    And I see text "Секретарь РК РО"
