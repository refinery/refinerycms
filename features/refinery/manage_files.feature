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
    
  Scenario: Files Delete
    When I go to the list of files
    When I upload the file at "features/uploads/refinery_is_awesome.txt"
    And I follow "Remove this file forever"
    #Then I should see "Flash message here.. not in place?"
    And I should have 0 files
    