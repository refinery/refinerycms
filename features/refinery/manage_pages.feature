Feature: Manage Pages
  In order to control the content on my website
  As an administrator
  I want to create and manage pages

  Scenario: Pages List
    Given I have pages titled Home, About
    And I am a logged in user
    When I go to the list of pages
    #Then show me the page
    Then I should see "Home"
    And I should see "About"
