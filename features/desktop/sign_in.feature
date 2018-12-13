Feature: Sign in
  Background:
    Given a user with email "user@example.com" and password "password"

  Scenario: with valid credentials
    When I try to sign in with email "user@example.com" and password "password"
    Then I am signed in as "user@example.com"
    And I see the main page

  Scenario: with invalid email
    When I try to sign in with email "foo@example.com" and password "password"
    Then I fail to sign in

  Scenario: with invalid password
    When I try to sign in with email "user@example.com" and password "foobar"
    Then I fail to sign in
