Feature: Membership application
  Scenario: as a visitor
    When I visit the main page
    And I click the button "Вступить"
    And I fill form with the following data:
      | key                                         | value            |
      | Фамилия                                     | Иванов           |
      | Имя                                         | Иван             |
      | Отчество                                    | Иванович         |
      | Профессия или род деятельности              | Программист      |
      | Адрес электронной почты                     | user@example.com |
      | Телефон                                     | 88005553535      |
      | Имя пользователя в Telegram                 | foobar           |
      | Членство в других общественных организациях | Не скажу         |
      | Комментарий                                 | Примите, плиз    |
    And I click the form button "Отправить заявление"
    Then I see the membership application tracking page

  Scenario: as a member
    Given I am signed in as party member
    When I visit the main page
    And I click the button "Ваше заявление"
    Then I see that I am already a party member
