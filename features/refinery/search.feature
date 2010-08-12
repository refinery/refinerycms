@search
Feature: Search
  In order find content more quickly
  As an administrator
  I want to use search

  Background:
    Given I am a logged in refinery user

  Scenario Outline: Search Existing Item
    Given I have a <item> titled "<title>"
    When I go to the list of <location>
    And I fill in "search" with "<title>"
    And I press "Search"
    Then I should see "<title>"

    Examples:
      |  item  | title  |   location   |
      |page    |testitem|pages         |
      |inquiry |testitem|inquiries     |
      |inquiry |testitem|spam inquiries|

  Scenario: Search File
    When I upload the file at "features/uploads/refinery_is_awesome.txt"
    And I go to the list of files
    And I fill in "search" with "Refinery Is Awesome"
    And I press "Search"
    Then I should see "Refinery Is Awesome"

  Scenario: Search Image
    When I upload the image at "features/uploads/beach.jpeg"
    And I go to the list of images
    And I fill in "search" with "Beach"
    And I press "Search"
    Then I should see "Beach"

  Scenario Outline: Search Nonexisting Item
    Given I have no <item>
    When I go to the list of <location>
    And I fill in "search" with "nonexisting"
    And I press "Search"
    Then I should see "Sorry, no results found"

    Examples:
      |  item   |   location   |
      |pages    |pages         |
      |images   |images        |
      |files    |files         |
      |inquiries|inquiries     |
      |inquiries|spam inquiries|
