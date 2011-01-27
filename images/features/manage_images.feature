@refinerycms @images @images-manage
Feature: Manage Images
  In order to control the content on my website
  As an administrator
  I want to create and manage images

  Background:
    Given I am a logged in refinery user
    And I have no images

  @images-valid @valid
  Scenario: Create Valid Image
    When I go to the list of images
    And I follow "Add new image"
    And I attach the image at "beach.jpeg"
    And I press "Save"
    Then the image "beach.jpeg" should have uploaded successfully
    And I should have 1 image
    And the image should have size "254718"
    And the image should have width "500"
    And the image should have height "375"
    And the image should have mime_type "image/jpeg"

  @images-invalid @invalid
  Scenario: Create Invalid Image (format)
    When I go to the list of images
    And I follow "Add new image"
    And I upload the image at "refinery_is_awesome.txt"
    And I press "Save"
    Then I should not see "successfully added"
    And I should have 0 images

  @images-edit @edit
  Scenario: Edit Existing Image
    When I upload the image at "beach.jpeg"
    And I go to the list of images
    And I follow "Edit this image"
    And I attach the image at "id-rather-be-here.jpg"
    And I press "Save"
    Then I should see "'Id Rather Be Here' was successfully updated."
    And I should have 1 image

  @images-delete @delete
  Scenario: Delete Image
    When I upload the image at "beach.jpeg"
    When I go to the list of images
    And I follow "Remove this image forever"
    Then I should see "'Beach' was successfully removed."
    And I should have 0 images
