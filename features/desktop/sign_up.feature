Feature: Sign up
  Scenario: as a visitor
    Given I visit "/users/sign_up"

    When I fill form with the following data:
      | key                  | value            |
      | Email                | user@example.com |
      | Пароль               | password         |
      | Подтверждение пароля | password         |
    And I click the form button "Регистрация"
    Then I am successfully signed up, but my email is unconfirmed
    And I received confirmation email as "user@example.com"

    When I try to sign in with email "user@example.com" and password "password"
    Then I fail to sign in because of unconfirmed email

    When I follow confirmation link for email "user@example.com"
    Then I see that my email is confirmed

    When I try to sign in with email "user@example.com" and password "password"
    Then I am signed in as "user@example.com"
