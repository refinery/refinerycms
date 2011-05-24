@refinerycms @dialogs
Feature: Dialogs
  In order to manage images and links when editing a page
  As an administrator
  I want to insert images and links on the WYMeditor

  Background:
    Given I am a logged in refinery user

  Scenario: Show the dialog with the iframe src for links
    When I go to the admin dialog for links path
    Then the page should have the css "iframe[src="/refinery/pages_dialogs/link_to"]"

  Scenario: Show the dialog with the iframe src for images
    When I go to the admin dialog for images path
    Then the page should have the css "iframe[src="/refinery/images/insert?modal=true"]"

  Scenario: Show the dialog with an empty iframe src
    When I go to the admin dialog for empty iframe src
    Then the page should have the css "iframe[src=""]"
