Feature: Staff people create
  Background:
    Given I am signed in as superuser
    Given I visit "/staff/people"
    Given I click "Создать"

  Scenario: with valid attributes
    When I fill form with the following data:
      | key     | value  |
      | Фамилия | Иванов |
      | Имя     | Павел  |
    And I click the form button "Отправить"
    Then I am at "/staff/people/\d+"
    And I see text "Иванов"
    And I see text "Павел"
    And I see text "Не относится к партии"

  Scenario: with invalid attributes:
    When I fill form with the following data:
      | key     | value  |
      | Фамилия | Иванов |
    And I click the form button "Отправить"
    Then I am at "/staff/people"
    And I see text "Пожалуйста, исправьте следующие ошибки"
    And I see text "Имя не может быть пустым"
