@refinerycms @search
Feature: Search
  In order find content more quickly
  As an administrator
  I want to use search

  Background:
    Given I am a logged in refinery user

  @search-existing
  Scenario Outline: Search Existing Item
    Given I have a <item> titled "<title>"
    When I go to the list of <location>
    And I fill in "search" with "<title>"
    And I press "Search"
    Then I should see "<title>"

    Examples:
      |  item  | title  |   location   |
      |page    |testitem|pages         |
      |setting |testitem|settings      |

  # This will only run when resources engine is installed.
  @search-file
  Scenario: Search File
    When I upload the file at "refinery_is_awesome.txt"
    And I go to the list of files
    And I fill in "search" with "Refinery Is Awesome"
    And I press "Search"
    Then I should see "Refinery Is Awesome"

  # This will only run when images engine is installed.
  @search-image
  Scenario: Search Image
    When I upload the image at "beach.jpeg"
    And I go to the list of images
    And I fill in "search" with "Beach"
    And I press "Search"
    Then I should see "Beach"

  @search-nonexisting
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
      |settings |settings      |

