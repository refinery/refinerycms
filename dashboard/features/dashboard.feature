@refinerycms @dashboard
Feature: Dashboard
  In order to see recent changes to my website
  As an administrator
  I want to use the dashboard

  Background:
    Given I am a logged in refinery user
    And my locale is en
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

  @dashboard-show
  Scenario: See Home Page Button
    When I follow "See home page"
    Then I should be on the home page

  @i18n
  Scenario: Translation options available
    When I go to the Dashboard
    Then I should see "English Change language"

  @i18n
  Scenario: Change Language to Slovenian and back to English
    When I go to the dashboard
    And I follow "English Change language"
    And I follow "Slovenian"
    Then I should be on the Dashboard
    And I should see "Slovenian Spremeni Jezik"
    And I should not see "Switch to your website"
    # Back to English
    When I follow "Slovenian Spremeni Jezik"
    And I follow "English"
    Then I should be on the Dashboard
    And I should see "Switch to your website"
    And I should not see "Spremeni Jezik"
