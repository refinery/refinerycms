Feature: Theme generation
  In order to create my own theme
  As a refinery user
  I want to generate a basic theme directory structure

  Scenario: Generating a theme with a name
    Given I have a refinery application
    When I generate a theme with the name of "modern"
    Then I should have a directory named "modern"
    And I should have a stylesheet named "modern/stylesheets/application.css"
    And I should have a stylesheet named "modern/stylesheets/home.css"
    And I should have a stylesheet named "modern/stylesheets/formatting.css"
    And I should have a layout named "modern/views/layouts/application.html.erb"
    And I should have a layout named "modern/views/pages/home.html.erb"
    And I should have a layout named "modern/views/pages/show.html.erb"
    And I should have a directory named "modern/javascripts"
