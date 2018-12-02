Feature: Passport creation
  Background:
    Given I visit "/passports/new"

  Scenario: all fields are filled
    Given I want to create the following passport:
      | key               | value    |
      | Фамилия           | Иванов   |
      | Имя               | Иван     |
      | Отчество          | Иванович |
      | Пол               | Мужской  |
      | Место рождения    | Москва   |
      | Серия             | 1234     |
      | Номер             | 567890   |
      | Кем выдан         | ФСМ      |
      | Код подразделения | 123-456  |
    When I fill the passport creation form
    When I click the passport creation button
    Then I see the passport page

  Scenario: only required fields are filled
    Given I want to create the following passport:
      | key               | value    |
      | Фамилия           | Петрова  |
      | Имя               | Мария    |
      | Отчество          |          |
      | Пол               | Женский  |
      | Место рождения    | Мурманск |
      | Серия             | 0001     |
      | Номер             | 000001   |
      | Кем выдан         | ФСМ      |
      | Код подразделения | 001-001  |
    When I fill the passport creation form
    When I click the passport creation button
    Then I see the passport page
