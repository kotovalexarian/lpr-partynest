Feature: Sign up
  Background:
    Given I visit "/users/sign_up"

  Scenario:
    When I fill form with the following data:
      | key                  | value            |
      | Email                | user@example.com |
      | Пароль               | password         |
      | Подтверждение пароля | password         |
    And I click the form button "Регистрация"
    Then I am successfully signed up, but my email is unconfirmed
    When I try to sign in with email "user@example.com" and password "password"
    Then I fail to sign in because of unconfirmed email
