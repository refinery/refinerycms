@refinerycms @pages @pages-manage
Feature: Manage Pages
  In order to control the content on my website
  As an administrator
  I want to create and manage pages

  Background:
    Given I am a logged in refinery user
    And I have no pages

  Scenario: Pages List
    Given I have pages titled Home, About
    When I go to the list of pages
    Then I should see "Home"
    And I should see "About"

  Scenario: Create Valid Page
    When I go to the list of pages
    And I follow "Add new page"
    And I fill in "Title" with "Pickles are Cucumbers Soaked in Evil"
    And I press "Save"
    Then I should see "'Pickles are Cucumbers Soaked in Evil' was successfully added."
    And I should have 1 page

  Scenario: Create Invalid Page (without title)
    When I go to the list of pages
    And I follow "Add new page"
    And I press "Save"
    Then I should see "Title can't be blank"
    And I should have 0 pages

  Scenario: Create Duplicate Page
    Given I only have pages titled Home, About
    When I go to the list of pages
    And I follow "Add new page"
    And I fill in "Title" with "About"
    And I press "Save"
    Then I should have 3 pages
    And I should have a page at /about--2

  Scenario: Delete Page
    Given I only have a page titled "test"
    When I go to the list of pages
    And I follow "Remove this page forever"
    Then I should see "'test' was successfully removed."
    And I should have 0 pages
    And I should have 0 page_parts

