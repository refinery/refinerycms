@refinerycms @dashboard
Feature: Dashboard
  In order to see recent changes to my website
  As an administrator
  I want to use the dashboard

  Background:
    Given I am a logged in refinery user
    When I go to the Dashboard

  @dashboard-add
  Scenario: Add New Page Button
    Given I have no pages
    When I follow "Add a new page"
    Then I should be on the new page form
    When I fill in "Title" with "Page test from Dashboard"
    And I press "Save"
    Then I should be on the Dashboard
    And I should see "'Page test from Dashboard' was successfully added."
    And I should have 1 page

  @dashboard-edit
  Scenario: Update a Page Button
    When I follow "Update a page"
    Then I should be on the list of pages

  @dashboard-edit
  Scenario: Upload a File Button
    When I follow "Upload a file"
    Then I should be on the new file form

  @dashboard-edit
  Scenario: Upload an Image Button
    When I follow "Upload an image"
    Then I should be on the new image form
