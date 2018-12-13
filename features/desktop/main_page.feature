Feature: Main page
  Scenario: as a visitor
    When I visit the main page
    Then I see the main page
    And I see the join button
    And I do not see the membership application button

    When I click the join button
    Then I see membership application creation form

  Scenario: as a guest account
    Given I am signed in as guest
    When I visit the main page
    Then I see the main page
    And I see the join button
    And I do not see the membership application button

    When I click the join button
    Then I see membership application creation form

  Scenario: as a usual account
    Given I am signed in with email "user@example.com"
    When I visit the main page
    Then I see the main page
    And I see the join button
    And I do not see the membership application button

    When I click the join button
    Then I see membership application creation form

  Scenario: when already sent a membership application as a visitor
    When I send a membership application
    And I visit the main page
    Then I see the main page
    And I do not see the join button
    And I see the membership application button

    When I click the membership application button
    Then I see the membership application tracking page

  Scenario: when already sent a membership application as a usual account
    Given I am signed in with email "user@example.com"
    When I send a membership application
    And I visit the main page
    Then I see the main page
    And I do not see the join button
    And I see the membership application button

    When I click the membership application button
    Then I see the membership application tracking page
