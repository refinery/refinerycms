Feature: Manage Inquiries
  In order to see inquiries left for me on my website
  As an Administrator
  I want to manage inquiries

  Background:
    Given I am a logged in user

  Scenario: Inquiries List
    Given I have an inquiry from "David Jones" with email "dave@refinerycms.com" and message "Hello, I really like your website.  Was it hard to build and maintain or could anyone do it?"
    When I go to the list of inquiries
    Then I should see "David Jones said Hello, I really like your website. Was it hard to build ..."
    And I should have 1 inquiries
