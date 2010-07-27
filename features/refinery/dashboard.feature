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
    
  Scenario: Change Language to Slovenian
    When I go to the dashboard
    And I follow "English Change Language"
    And I follow "Slovenian"
    Then I should be on the dashboard
    And I should see "Slovenian Change Language"
    And I should not see "Switch to your website"