Feature: Main page
  Background:
    Given I visit "/"

  Scenario: It works
    Then I see CSS "h1" with text "Либертарианская партия России"
