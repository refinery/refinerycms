@refinerycms @pages @pages-translate @i18n
Feature: Translate Pages
  In order to make the content on my website accessible in many countries
  As a translator
  I want to translate manage pages

  Background:
    Given A Refinery user exists
    And I am a logged in Refinery Translator
    And I have pages titled Home, About

  Scenario: Pages List
    When I go to the list of pages
    Then I should see "Home"
    And I should see "About"

  Scenario: Add page to main locale
    When I go to the list of pages
    And I follow "Add new page"
    And I fill in "Title" with "Pickles are Cucumbers Soaked in Evil"
    And I press "Save"
    Then I should see "You do not have the required permission to modify pages in this language"
    And I should have 2 pages

  Scenario: Add page to second locale
    Given I have frontend locales en, fr
    When I go to the list of pages
    And I follow "Add new page"
    And I follow "Fr" within "#switch_locale_picker"
    And I fill in "Title" with "Pickles sont Concombres Trempé dans le Mal"
    And I press "Save"
    Then I should see "'Pickles sont Concombres Trempé dans le Mal' was successfully added."
    And I should have 3 pages

  Scenario: Delete page from main locale
    Given I only have a page titled "test"
    When I go to the list of pages
    And I follow "Remove this page forever"
    Then I should see "You do not have the required permission to modify pages in this language."
    And I should have 1 pages