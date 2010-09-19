@files @files-manage
Feature: Manage Files
  In order to control the content on my website
  As an administrator
  I want to create and manage files

  Background:
    Given I am a logged in refinery user
    And I have no files

  Scenario: Create Valid File
    When I go to the list of files
    And I follow "Upload New File"
    And I attach the file at "refinery_is_awesome.txt"
    And I press "Save"
    Then the file "refinery_is_awesome.txt" should have uploaded successfully
    And I should have 1 file

  Scenario: Edit Existing File
    When I upload the file at "refinery_is_awesome.txt"
    And I go to the list of files
    And I follow "Edit this file"
    And I attach the file at "beach.jpeg"
    And I press "Save"
    Then the file "beach.jpeg" should have uploaded successfully
    And I should have 1 file

  Scenario: Download Existing File
    When I upload the file at "refinery_is_awesome.txt"
    And I go to the list of files
    And I follow "Download this file"
    Then I should see "http://www.refineryhq.com/"

  Scenario: Files Delete
    When I upload the file at "refinery_is_awesome.txt"
    And I go to the list of files
    And I follow "Remove this file forever"
    Then I should see "'Refinery Is Awesome' was successfully removed."
    And I should have 0 files
