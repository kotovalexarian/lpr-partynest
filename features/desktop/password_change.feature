Feature: Password change
  Scenario: with valid credentials
    Given I am signed in with email "user@example.com" and password "password"
    When I visit "/users/edit"
    And I fill form with the following data:
      | key                  | value    |
      | Пароль               | q1w2e3r4 |
      | Подтверждение пароля | q1w2e3r4 |
      | Текущий пароль       | password |
    And I click the form button "Обновить"
    Then the password is successfully changed

    When I try to sign out
    Then I am successfully signed out

    When I try to sign in with email "user@example.com" and password "password"
    Then I fail to sign in

    When I try to sign in with email "user@example.com" and password "q1w2e3r4"
    Then I am signed in as "user@example.com"
