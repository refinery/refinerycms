@refinerycms @authentication @users @users-manage
Feature: Manage Users
  In order to control who can access my website's backend
  As an administrator
  I want to create and manage users

  Background:
    Given I have no users

  Scenario: When there are no users, you are invited to create a user
    When I go to the home page
    Then I should see "There are no users yet, so we'll set you up first."

  @users-add @add
  Scenario: When there are no users, you can create a user
    When I go to the home page
    And I follow "Continue..."
    And I should see "Fill out your details below so that we can get you started."
    And I fill in "Username" with "cucumber"
    And I fill in "Email" with "green@cucumber.com"
    And I fill in "Password" with "greenandjuicy"
    And I fill in "Password confirmation" with "greenandjuicy"
    And I press "Sign up"
    Then I should see "Welcome to Refinery, cucumber."
    And I should see "Latest Activity"
    And I should have 1 user

  @users-list @list
  Scenario: User List
    Given I have a user named "steven"
    And I am a logged in refinery user
    When I go to the list of users
    Then I should see "steven"

  @users-add @add
  Scenario: Create User
    Given I have a user named "steven"
    And I am a logged in refinery user
    When I go to the list of users
    And I follow "Add new user"
    And I fill in "Username" with "cucumber"
    And I fill in "Email" with "green@cucumber.com"
    And I fill in "Password" with "greenandjuicy"
    And I fill in "Password confirmation" with "greenandjuicy"
    And I press "Save"
    Then I should be on the list of users
    And I should see "cucumber was successfully added."
    And I should see "cucumber (green@cucumber.com)"

  @users-edit @edit
  Scenario: Edit User
    Given I have a user named "steven"
    And I am a logged in refinery user
    When I go to the list of users
    And I follow "Edit this user"
    And I fill in "Username" with "cucumber"
    And I fill in "Email" with "green@cucumber.com"
    And I press "Save"
    Then I should be on the list of users
    And I should see "cucumber was successfully updated."
    And I should see "cucumber (green@cucumber.com)"

  @users-dashboard @add
  Scenario: Add User
    Given I have a user named "steven"
    And I am a logged in refinery user
    When I go to the list of users
    And I follow "Add new user"
    And I fill in "Username" with "marian"
    And I fill in "Email" with "green@cucumber.com"
    And I fill in "Password" with "greenandjuicy"
    And I fill in "Password confirmation" with "greenandjuicy"
    And I press "Save"
    Then I should be on the list of users
    When I go to the Dashboard
    Then I should see "Marian user was added"

  @users-dashboard @edit
  Scenario: Edit User
    Given I have a user named "steven"
    And I am a logged in refinery user
    When I go to the list of users
    And I follow "Edit this user"
    And I fill in "Username" with "marian"
    And I press "Save"
    Then I should be on the list of users
    When I go to the Dashboard
    Then I should see "Marian user was updated"
