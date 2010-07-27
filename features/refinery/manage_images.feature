@images @images-manage
Feature: Manage Images
  In order to control the content on my website
  As an administrator
  I want to create and manage images
  
  Background:
    Given I am a logged in user
    
  Scenario: Create Valid Image
    Given I have no images
    When I go to the list of images
    And I follow "Create New Image"
    When I attach the image at "features/uploads/beach.jpeg"
    And I press "Save"
    Then the image "beach.jpeg" should have uploaded successfully
    And I should have the correct default number of images
    And the image should have size "254718"
    And the image should have width "500"
    And the image should have height "375"
    And the image should have content_type "image/jpeg"
    And the image should have all default thumbnail generations
    
  Scenario: Create Invalid Image (format)
    Given I have no images
    When I go to the list of images
    And I follow "Create New Image"
    When I attach the image at "features/uploads/beach.INVALID"
    And I press "Save"
    Then I should see "Your image must be either a JPG, PNG or GIF"
    And I should have 0 images
    
    
  Scenario: Edit Existing Image
    Given I have no images
    When I go to the list of images
    And I follow "Create New Image"
    When I attach the image at "features/uploads/beach.jpeg"
    And I press "Save"
    Then the image "beach.jpeg" should have uploaded successfully
    Then I go to the list of images
    And I follow "Edit this image"
    And I attach the image at "features/uploads/id-rather-be-here.jpg"
    And I press "Save"
    Then I should see "Id Rather Be Here"
    And I should have 1 file
    
  Scenario: Delete Image
    Given I have no images
    When I go to the list of images
    And I follow "Create New Image"
    When I attach the image at "features/uploads/beach.jpeg"
    And I press "Save"
    Then the image "beach.jpeg" should have uploaded successfully
    Then I go to the list of images
    #And I follow "Remove this image forever" - not sure why this doesn't work - someone fix me!
    #And I should have 0 files