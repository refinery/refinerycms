@files @files-manage
Feature: Manage Files
  In order to control the content on my website
  As an administrator
  I want to create and manage files
  
  Background:
    Given I am a logged in user
    
  Scenario: Create Valid File
    Given I have no files
    When I go to the list of files
    And I follow "Upload New File"
    When I attach the file at "features/uploads/refinery_is_awesome.txt"
    And I press "Save"
    Then the file "refinery_is_awesome.txt" should have uploaded successfully
    And I should have 1 file
    
  Scenario: Edit Existing File
    Given I have no files
    When I upload the file at "features/uploads/refinery_is_awesome.txt"
    Then I go to the list of files
    And I follow "Edit this file"
    And I attach the file at "features/uploads/beach.jpeg"
    And I press "Save"
    Then the file "beach.jpeg" should have uploaded successfully
    And I should have 1 file
    
  Scenario: Download Existing File
    Given I have no files
    When I upload the file at "features/uploads/refinery_is_awesome.txt"
    Then I go to the list of files
    And I follow "Download this file"
    Then I should see "http://www.refineryhq.com/"
    
  Scenario: Files Delete
    Given I have no files
    When I upload the file at "features/uploads/refinery_is_awesome.txt"
    Then I go to the list of files
    # fix me please!
    And I follow "Remove this file forever"
    #Then I should see "Flash message here.. not in place?"
    And I should have 0 files
    