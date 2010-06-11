Feature: Manage Pages
  In order to create a page
  As an administrator
  I want to create and manage pages
  
  Scenario: Pages List
    Given I have pages titled Home, About
    When I go to the list of pages
    Then I should see "Home"
    And "About"