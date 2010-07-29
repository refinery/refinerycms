@dashboard
Feature: Dashboard
  In order to see recent changes to my website
  As an administrator
  I want to use the dashboard
  
  Background:
    Given I am a logged in refinery user
  
  Scenario: Translation options available
    When I go to the Dashboard
    Then I should see "English Change Language"
    
  Scenario: Change Language to Slovenian and back to English
    When I go to the dashboard
    And I follow "English Change Language"
    And I follow "Slovenian"
    Then I should be on the dashboard
    And I should see "Slovenian Spremeni Jezik"
    And I should not see "Switch to your website"
    # Back to English
    When I follow "Slovenian Spremeni Jezik"
    And I follow "English"
    Then I should be on the dashboard
    And I should see "Switch to your website"
    And I should not see "Spremeni Jezik"
    
  Scenario: Upload an Image Button
    
  Scenario: Add New Page Button
    When I go to the dashboard
    And I follow "Add a new page"
    Then I should be on the new page form
    When I fill in "Title" with "Page test from Dashboard"
    And I press "Save"
    Then I should be on the dashboard
    And I should see "'Page test from Dashboard' was successfully created."
    And I should see "Page test from dashboard page was created"