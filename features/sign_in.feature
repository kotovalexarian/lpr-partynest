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
    Then I am at "/"
    And I see CSS "h1" with text "Либертарианская партия России"
    And I am logged in as "user@example.com"
