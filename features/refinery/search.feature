Feature: Search
  In order find content more quickly
  As an administrator
  I want to use search

  Background:
    Given I am a logged in refinery user

  Scenario Outline: Search Existing Item
    Given I have test <item> titled "<title>"
    When I go to the list of <location>
    And I fill in "search" with "<title>"
    And I press "Search"
   Then I should see "<title>"

    Examples:
      |  item  | title  |   location   |
      |page    |testitem|pages         |
      |image   |testitem|images        |
      |file    |testitem|files         |
      |inquiry |testitem|inquiries     |
      |inquiry |testitem|spam inquiries|

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
