Feature: Manage Pages
  In order to control the content on my website
  As an administrator
  I want to create and manage pages

  Scenario: Pages List
    Given I have pages titled Home, About
    And I am a logged in user
    When I go to the list of pages
    Then I should see "Home"
    And I should see "About"

  Scenario: Create Valid Page
    Given I am a logged in user
    And I have no pages
    And I am on the list of pages
    When I follow "Create New Page"
    And I fill in "Title" with "Pickles are Cucumbers Soaked in Evil"
    And I press "Save"
    Then I should see "'Pickles are Cucumbers Soaked in Evil' was successfully created."
    And I should have 1 page

  Scenario: Create Invalid Page (without title)
    Given I am a logged in user
    And I have no pages
    And I am on the list of pages
    When I follow "Create New Page"
    And I press "Save"
    Then I should see "Title can't be blank"
    And I should have 0 pages
