@inquiries
Feature: Manage Inquiries
  In order to see inquiries left for me on my website
  As an Administrator
  I want to manage inquiries

  Background:
    Given I am a logged in user
    And I have an inquiry from "David Jones" with email "dave@refinerycms.com" and message "Hello, I really like your website.  Was it hard to build and maintain or could anyone do it?"

  Scenario: Inquiries List
    When I go to the list of inquiries
    Then I should see "David Jones said Hello, I really like your website. Was it hard to build ..."
    And I should have 1 inquiries
    
  Scenario: Inquiries Show
    When I go to the list of inquiries
    And I follow "Read the inquiry"
    Then I should see "From David Jones [dave@refinerycms.com]"
    And I should see "Hello, I really like your website. Was it hard to build and maintain or could anyone do it?"
    And I should see "Age"
    And I should see "Back to all Inquiries"
    And I should see "Remove this inquiry forever"
    
  Scenario: Inquiries Delete
    When I go to the list of inquiries
    And I follow "Read the inquiry"
    #And I confirm the following javascript confirmation <-- this needs to happen.
    And I follow "Remove this inquiry forever"
    Then I should see "'David Jones' was successfully destroyed."
    And I should have 0 inquiries
    