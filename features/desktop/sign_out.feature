Feature: Sign out
  Scenario: as a usual account
    Given I am signed in with email "user@example.com"
    When I try to sign out
    Then I am successfully signed out
