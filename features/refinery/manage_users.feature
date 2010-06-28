Feature: Manage Users
  In order to control who can access my website's backend
  As an administrator
  I want to create and manage users
  
  Background:
    Given I am a logged in user

  Scenario: User List
    Given I have a user named resolve
    When I go to the list of users
    Then I should see "resolve"