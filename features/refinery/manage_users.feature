Feature: Manage Users
  In order to control who can access my website's backend
  As an administrator
  I want to create and manage users

  Scenario: When there are no users, you are invited to create a user
    Given I have no users
    When I go to the home page
    Then I should see "There are no users yet, so we'll set you up first."

  Scenario: When there are no users, you can create a user
    Given I have no users
    And I go to the home page
    When I press "Continue..."
    And I should see "Fill out your details below so that we can get you started."
    And I fill in "Login" with "cucumber"
    And I fill in "Email" with "green@cucumber.com"
    And I fill in "Password" with "greenandjuicy"
    And I fill in "Password confirmation" with "greenandjuicy"
    And I press "Sign up"
    Then I should see "Welcome to Refinery, cucumber."
    And I should see "Latest Activity"
    And I should have 1 user

  Scenario: User List
    Given I have a user named "resolve"
    And I am a logged in refinery user
    When I go to the list of users
    Then I should see "resolve"

  Scenario: Create User
    Given I have a user named "resolve"
    And I am a logged in refinery user
    When I go to the list of users
    And I follow "Create New User"
    And I fill in "Login" with "cucumber"
    And I fill in "Email" with "green@cucumber.com"
    And I fill in "Password" with "greenandjuicy"
    And I fill in "Password confirmation" with "greenandjuicy"
    And I press "Save"
    Then I should be on the list of users
    And I should see "cucumber was successfully created."
    And I should see "cucumber (green@cucumber.com)"

  Scenario: Edit User
    Given I have a user named "resolve"
    And I am a logged in refinery user
    When I go to the list of users
    And I follow "Edit this user"
    And I fill in "Login" with "cucumber"
    And I fill in "Email" with "green@cucumber.com"
    And I press "Save"
    Then I should be on the list of users
    And I should see "cucumber was successfully updated."
    And I should see "cucumber (green@cucumber.com)"
