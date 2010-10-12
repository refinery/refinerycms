@<%= plural_name %>
Feature: <%= plural_name.titleize %>
  In order to have <%= plural_name %> on my website
  As an administrator
  I want to manage <%= plural_name %>

  Background:
     Given I am a logged in refinery user
     And I have no <%= plural_name %>
<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? %>
   Scenario: <%= plural_name.titleize %> List
     Given I have <%= plural_name %> titled UniqueTitleOne, UniqueTitleTwo
     When I go to the list of <%= plural_name %>
     Then I should see "UniqueTitleOne"
     And I should see "UniqueTitleTwo"

   Scenario: Create Valid <%= singular_name.titleize %>
     When I go to the list of <%= plural_name %>
     And I follow "Add New <%= singular_name.titleize %>"
     And I fill in "<%= title.name.titleize %>" with "This is a test of the first string field"
     And I press "Save"
     Then I should see "'This is a test of the first string field' was successfully added."
     And I should have 1 <%= singular_name %>

   Scenario: Create Invalid <%= singular_name.titleize %> (without <%= title.name %>)
     When I go to the list of <%= plural_name %>
     And I follow "Add New <%= singular_name.titleize %>"
     And I press "Save"
     Then I should see "<%= title.name.titleize %> can't be blank"
     And I should have 0 <%= plural_name %>

   Scenario: Create Duplicate <%= singular_name.titleize %>
     Given I only have <%= plural_name %> titled UniqueTitleOne, UniqueTitleTwo
     When I go to the list of <%= plural_name %>
     And I follow "Add New <%= singular_name.titleize %>"
     And I fill in "<%= title.name.titleize %>" with "UniqueTitleTwo"
     And I press "Save"
     Then I should see "There were problems"
     And I should have 2 <%= plural_name %>

   Scenario: Delete <%= singular_name.titleize %>
     Given I only have <%= plural_name %> titled UniqueTitleOne
     When I go to the list of <%= plural_name %>
     And I follow "Remove this <%= singular_name.titleize.downcase %> forever"
     Then I should see "'UniqueTitleOne' was successfully removed."
     And I should have 0 <%= plural_name %>
 <% end -%>
