Feature: Theme generation
  In order to create my own theme
  As a refinery user
  I want to generate a basic theme directory structure

  Scenario: Generating a theme with a name
    Given I have a refinery application
    When I generate a theme with the name of "modern"
    Then I should have a directory "themes/modern"
    And I should have a file "themes/modern/stylesheets/application.css"
    And I should have a file "themes/modern/stylesheets/home.css"
    And I should have a file "themes/modern/stylesheets/formatting.css"
    And I should have a file "themes/modern/views/layouts/application.html.erb"
    And I should have a file "themes/modern/views/pages/home.html.erb"
    And I should have a file "themes/modern/views/pages/show.html.erb"
    And I should have a directory "themes/modern/javascripts"
