Feature: Sign in
  Background:
    Given a user with email "user@example.com" and password "password"
    When I visit "/users/sign_in"

  Scenario: with valid credentials
    When I fill form with the following data:
      | key    | value            |
      | Email  | user@example.com |
      | Пароль | password         |
    And I click the form button "Войти"
    Then I am at "/"
    And I see CSS "h1" with text "Либертарианская партия России"

  Scenario: with invalid email
    When I fill form with the following data:
      | key    | value           |
      | Email  | foo@example.com |
      | Пароль | password        |
    And I click the form button "Войти"
    Then I am at "/users/sign_in"
    And I see CSS "div.alert.alert-warning" with text "Неправильный Email или пароль."

  Scenario: with invalid password
    When I fill form with the following data:
      | key    | value            |
      | Email  | user@example.com |
      | Пароль | foobar           |
    And I click the form button "Войти"
    Then I am at "/users/sign_in"
    And I see CSS "div.alert.alert-warning" with text "Неправильный Email или пароль."
