Feature: Main page
  Scenario: as a visitor
    When I visit the main page
    Then I see the main page

  Scenario: as a usual account
    Given I am signed in with email "user@example.com"
    When I visit the main page
    Then I see the main page
