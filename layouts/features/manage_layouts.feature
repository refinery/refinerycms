@layouts
Feature: Layouts
  In order to have layouts on my website
  As an administrator
  I want to manage layouts

  Background:
    Given I am a logged in refinery user
    And I have no layouts

  @layouts-list @list
  Scenario: Layouts List
   Given I have layouts titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of layouts
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @layouts-valid @valid
  Scenario: Create Valid Layout
    When I go to the list of layouts
    And I follow "Add New Layout"
    And I fill in "Template Name" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 layout

  @layouts-invalid @invalid
  Scenario: Create Invalid Layout (without template_name)
    When I go to the list of layouts
    And I follow "Add New Layout"
    And I press "Save"
    Then I should see "Template Name can't be blank"
    And I should have 0 layouts

  @layouts-edit @edit
  Scenario: Edit Existing Layout
    Given I have layouts titled "A template_name"
    When I go to the list of layouts
    And I follow "Edit this layout" within ".actions"
    Then I fill in "Template Name" with "A different template_name"
    And I press "Save"
    Then I should see "'A different template_name' was successfully updated."
    And I should be on the list of layouts
    And I should not see "A template_name"

  @layouts-duplicate @duplicate
  Scenario: Create Duplicate Layout
    Given I only have layouts titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of layouts
    And I follow "Add New Layout"
    And I fill in "Template Name" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 layouts

  @layouts-delete @delete
  Scenario: Delete Layout
    Given I only have layouts titled UniqueTitleOne
    When I go to the list of layouts
    And I follow "Remove this layout forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 layouts
 