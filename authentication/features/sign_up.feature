@refinerycms @authentication @users @users-sign-up
Feature: Sign up
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