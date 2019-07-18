Feature: Staff person comments
  Background:
    Given I am signed in as superuser
    Given there is a person
    Then I click "Сервисы для сотрудников"
    And I click "Люди"
    And I click font awesome "eye"
    And I click first "Комментарии"

  Scenario: without attachment
    When I fill form with the following data:
      | key   | value  |
      | Текст | foobar |
    And I click the form button "Отправить"
    Then I see text "foobar"

  Scenario: with attachment
    When I fill form with the following data:
      | key   | value  |
      | Текст | foobar |
    And I upload "avatar.jpg" as "Приложение"
    And I click the form button "Отправить"
    Then I see text "foobar"
    And I see text "avatar.jpg"
