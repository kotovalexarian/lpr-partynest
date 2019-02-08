Feature: Roles
  Background:
    Given I am signed in as superuser

  Scenario:
    When I visit "/settings/roles"
    Then I see text "Суперпользователь"

    When I click the button "Отозвать"
    Then I do not see text "Суперпользователь"
