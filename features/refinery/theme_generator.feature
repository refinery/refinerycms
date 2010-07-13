Feature: Theme generation
  In order to create my own theme
  As a refinery user
  I want to generate a basic theme directory structure

  Scenario: Generating a theme with a name
    Given I have a refinery application
    When I generate a theme with the name of "sexy_layout"
    Then I should have a directory named "sexy_layout"
    And I should have a stylsheet named "sexy_layout/stylesheets/application.css"
    And I should have a layout named "sexy_layout/views/layouts/application.html.erb"
    And I should have a layout named "sexy_layout/views/pages/index.html.erb"
    And I should have a layout named "sexy_layout/views/pages/show.html.erb"
    And I should have a directory named "sexy_layout/javascripts"
    And I should have a "LICENSE"
    And I should have a "README"
