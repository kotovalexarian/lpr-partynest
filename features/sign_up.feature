Feature: Sign up
  Background:
    Given I visit sign up page

  Scenario:
    When I fill form with the following data:
      | key                  | value            |
      | Email                | user@example.com |
      | Пароль               | q1w2e3r4t5y6     |
      | Подтверждение пароля | q1w2e3r4t5y6     |
    And I click the form button "Регистрация"
    Then I see main page
