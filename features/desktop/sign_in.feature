Feature: Sign in
  Background:
    Given a user with email "user@example.com" and password "password"

  Scenario: with valid credentials
    When I try to sign in with email "user@example.com" and password "password"
    Then I am at "/"
    And I see CSS "h1" with text "Либертарианская партия России"

  Scenario: with invalid email
    When I try to sign in with email "foo@example.com" and password "password"
    Then I am at "/users/sign_in"
    And I see CSS "div.alert.alert-warning" with text "Неправильный Email или пароль."

  Scenario: with invalid password
    When I try to sign in with email "user@example.com" and password "foobar"
    Then I am at "/users/sign_in"
    And I see CSS "div.alert.alert-warning" with text "Неправильный Email или пароль."
