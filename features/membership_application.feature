Feature: Membership application
  Background:
    Given I visit "/"
    Then I click the button "Вступить"

  Scenario:
    When I fill form with the following data:
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
    Then I am at "/membership_applications/\d+"
    And I see text "Ваша заявка в обработке"
