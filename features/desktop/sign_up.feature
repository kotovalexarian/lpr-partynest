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

  Scenario: as a guest account
    When I visit the main page
    Then I see the main page
    And I see the join button
    And I do not see the membership application button

    When I click the button "Вступить"
    And I fill form with the following data:
      | key                     | value            |
      | Фамилия                 | Иванов           |
      | Имя                     | Иван             |
      | Адрес электронной почты | user@example.com |
      | Телефон                 | 88005553535      |
    And I click the form button "Отправить заявление"
    Then I see the membership application tracking page

    When I click the button "Регистрация"
    And I fill form with the following data:
      | key                  | value            |
      | Email                | user@example.com |
      | Пароль               | password         |
      | Подтверждение пароля | password         |
    And I click the form button "Регистрация"
    Then I am successfully signed up, but my email is unconfirmed
    And I received confirmation email as "user@example.com"

    When I follow confirmation link for email "user@example.com"
    Then I see that my email is confirmed

    When I try to sign in with email "user@example.com" and password "password"
    Then I am signed in as "user@example.com"

    When I visit the main page
    Then I see the main page
    And I do not see the join button
    And I see the membership application button

    When I click the membership application button
    Then I see the membership application tracking page
