@images @images-manage
Feature: Manage Images
  In order to control the content on my website
  As an administrator
  I want to create and manage images

  Background:
    Given I am a logged in refinery user
    And I have no images

  Scenario: Create Valid Image
    When I go to the list of images
    And I follow "Create New Image"
    And I attach the image at "features/uploads/beach.jpeg"
    And I press "Save"
    Then the image "beach.jpeg" should have uploaded successfully
    And I should have 1 image
    And the image should have size "254718"
    And the image should have width "500"
    And the image should have height "375"
    And the image should have mime_type "image/jpeg"

  Scenario: Create Invalid Image (format)
    When I go to the list of images
    And I follow "Create New Image"
    And I attach the image at "features/uploads/refinery_is_awesome.txt"
    And I press "Save"
    Then I should not see "successfully created"
    And I should have 0 images

  Scenario: Edit Existing Image
    When I upload the image at "features/uploads/beach.jpeg"
    And I go to the list of images
    And I follow "Edit this image"
    And I attach the image at "features/uploads/id-rather-be-here.jpg"
    And I press "Save"
    Then I should see "'Id Rather Be Here' was successfully updated."
    And I should have 1 image

  Scenario: Delete Image
    When I upload the image at "features/uploads/beach.jpeg"
    When I go to the list of images
    And I follow "Remove this image forever"
    Then I should see "'Beach' was successfully destroyed. "
    And I should have 0 images
