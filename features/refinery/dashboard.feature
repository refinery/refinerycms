@dashboard
Feature: Dashboard
  In order to see recent changes to my website
  As an administrator
  I want to use the dashboard
  
  Background:
    Given I am a logged in user
  
  Scenario: Translation options available
    When I go to the Dashboard
    Then I should see "English"
    And I should see "Change Language"