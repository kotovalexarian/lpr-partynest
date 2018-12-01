@wip
Feature: Sign in
  Background:
    Given I visit "/users/sign_in"

  Scenario:
    When I fill form with the following data:
      | key    | value            |
      | Email  | user@example.com |
      | Пароль | q1w2e3r4t5y6     |
    And I click the form button "Войти"
    Then I see main page
    And I am logged in as "user@example.com"
