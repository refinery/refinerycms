@images @images-manage
Feature: Manage Images
  In order to control the content on my website
  As an administrator
  I want to create and manage images

  Background:
    Given I am a logged in refinery user

  Scenario: Create Valid Image
    Given I have no images
    When I go to the list of images
    And I follow "Create New Image"
    And I attach the image at "features/uploads/beach.jpeg"
    And I press "Save"
    Then the image "beach.jpeg" should have uploaded successfully
    And I should have the correct default number of images
    And the image should have size "254718"
    And the image should have width "500"
    And the image should have height "375"
    And the image should have content_type "image/jpeg"
    #This line handles properly if you have any plugins installed.  Ie: Portfolio will generate two additional thumbs.
    And the image should have all default thumbnail generations

  Scenario: Create Invalid Image (format)
    Given I have no images
    When I go to the list of images
    And I follow "Create New Image"
    And I attach the image at "features/uploads/beach.INVALID"
    And I press "Save"
    Then I should see "Your image must be either a JPG, PNG or GIF"
    And I should have 0 images

  Scenario: Edit Existing Image
    Given I have test image titled "beach.jpg"
    When I go to the list of images
    And I follow "Edit this image"
    And I attach the image at "features/uploads/id-rather-be-here.jpg"
    And I press "Save"
    Then I should see "'Id Rather Be Here' was successfully updated."
    And I should have the correct default number of images

  Scenario: Delete Image
    Given I have test image titled "beach.jpg"
    When I go to the list of images
    And I follow "Remove this image forever"
    Then I should see "'Beach' was successfully destroyed. "
    And I should have 0 images
