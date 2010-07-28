Feature: Plugin generation
  In order to create my own plugin
  As a refinery user
  I want to generate a basic plugin directory structure

  Scenario: Generating a plugin with a name
    Given I have a refinery application
    When I generate a plugin with the name of "product"
    Then I should have a directory named "products"
    And I should have a file named ""
