@refinerycms @pages @pages-visit @visit-pages
Feature: Visit Pages
  In order to view the content on this website
  As a visitor
  I want to view pages

  Background:
    Given A Refinery user exists
    And I have a page titled "Home" with a custom url "/"
    And I have a page titled "About"
    And I have a page titled "ä ö ü spéciål chåråctÉrs"
    And I have a page titled "Hidden"
    And the page titled "Hidden" is a child of Home
    And the page titled "Hidden" is not shown in the menu

  @pages-visit-home
  Scenario: Home Page
    When I go to the home page
    Then I should see "Home"
    And I should see "About"
    And I should see "Home" within ".selected"

  @pages-visit-show
  Scenario: Content Page
    When I go to the page titled "About"
    Then I should see "Home"
    And I should see "About"
    And I should see "About" within ".selected > a"

  @pages-visit-special
  Scenario: Special Characters Title
    When I go to the page titled "ä ö ü spéciål chåråctÉrs"
    Then I should see "Home"
    And I should see "About"
    And I should see "ä ö ü spéciål chåråctÉrs"
    And I should see "ä ö ü spéciål chåråctÉrs" within ".selected > a"

  @pages-visit-special
  Scenario: Special Characters Title as submenu page
    Given the page titled "ä ö ü spéciål chåråctÉrs" is a child of About
    When I go to the page titled "ä ö ü spéciål chåråctÉrs"
    Then I should see "Home"
    And I should see "About"
    And I should see "ä ö ü spéciål chåråctÉrs"
    And I should see "ä ö ü spéciål chåråctÉrs" within ".selected * > .selected a"

  @pages-visit-hidden
  Scenario: Hidden Page
    When I go to the page titled "Hidden"
    Then I should see "Home"
    And I should see "About"
    And I should see "Hidden"
    And I should not see "Hidden" within "nav"

  @pages-visit-skip
  Scenario: Skip to first child
    Given I have a page titled "Child Page"
    And the page titled "Child Page" is a child of About
    And the page titled "About" is set to skip to first child
    When I go to the page titled "About"
    Then I should see "Child Page" within ".selected * > .selected a"

  @pages-visit-i18n
  Scenario: Translated URI
    Given I have frontend locales "en, de"
    And the page titled "Home" is fully translated
    When I go to the page titled "Home" with locale "de"
    Then I should see "Home" within ".selected > a"
