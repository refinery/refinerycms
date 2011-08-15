@refinerycms @engine-generator @generator
Feature: Engine generation
  In order to create my own engine
  As a refinery user
  I want to generate a basic engine directory structure

  Scenario: Generating an engine with a name
    Given I have a refinery application
    When I generate an engine with the arguments of "cucumber_product_test title:string description:text image:image brochure:resource"
    Then I should have a directory "vendor/engines/cucumber_product_tests"
    And I should have a directory "vendor/engines/cucumber_product_tests/app"
    And I should have a directory "vendor/engines/cucumber_product_tests/lib"
    And I should have a directory "vendor/engines/cucumber_product_tests/config"
    And I should have a file "vendor/engines/cucumber_product_tests/app/controllers/refinery/admin/cucumber_product_tests_controller.rb"
    And I should have a file "vendor/engines/cucumber_product_tests/app/controllers/refinery/cucumber_product_tests_controller.rb"
    And I should have a file "vendor/engines/cucumber_product_tests/app/models/refinery/cucumber_product_test.rb"
    And I should have a file "vendor/engines/cucumber_product_tests/config/routes.rb"
    And I should have a file "vendor/engines/cucumber_product_tests/config/locales/en.yml"
    And I should have a file "vendor/engines/cucumber_product_tests/lib/refinerycms-cucumber_product_tests.rb"
    And I should have a file "vendor/engines/cucumber_product_tests/app/views/refinery/admin/cucumber_product_tests/_form.html.erb"
    And I should have a file "vendor/engines/cucumber_product_tests/app/views/refinery/admin/cucumber_product_tests/_sortable_list.html.erb"
    And I should have a file "vendor/engines/cucumber_product_tests/app/views/refinery/admin/cucumber_product_tests/edit.html.erb"
    And I should have a file "vendor/engines/cucumber_product_tests/app/views/refinery/admin/cucumber_product_tests/index.html.erb"
    And I should have a file "vendor/engines/cucumber_product_tests/app/views/refinery/admin/cucumber_product_tests/new.html.erb"
    And I should have a file "vendor/engines/cucumber_product_tests/app/views/refinery/admin/cucumber_product_tests/_cucumber_product_test.html.erb"
    And I should have a file "vendor/engines/cucumber_product_tests/app/views/refinery/cucumber_product_tests/index.html.erb"
    And I should have a file "vendor/engines/cucumber_product_tests/app/views/refinery/cucumber_product_tests/show.html.erb"