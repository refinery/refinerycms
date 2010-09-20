@engine-generator @generator
Feature: Engine generation
  In order to create my own engine
  As a refinery user
  I want to generate a basic engine directory structure

  Scenario: Generating an engine with a name
    Given I have a refinery application
    When I generate an engine with the arguments of "product title:string description:text image:image brochure:resource"
    Then I should have a directory "vendor/engines/products"
    And I should have a directory "vendor/engines/products/app"
    And I should have a directory "vendor/engines/products/lib"
    And I should have a directory "vendor/engines/products/config"
    And I should have a file "vendor/engines/products/app/controllers/admin/products_controller.rb"
    And I should have a file "vendor/engines/products/app/controllers/products_controller.rb"
    And I should have a file "vendor/engines/products/app/models/product.rb"
    And I should have a file "vendor/engines/products/config/routes.rb"
    And I should have a file "vendor/engines/products/config/locales/en.yml"
    And I should have a file "vendor/engines/products/lib/products.rb"
    And I should have a file "vendor/engines/products/app/views/admin/products/_form.html.erb"
    And I should have a file "vendor/engines/products/app/views/admin/products/_sortable_list.html.erb"
    And I should have a file "vendor/engines/products/app/views/admin/products/edit.html.erb"
    And I should have a file "vendor/engines/products/app/views/admin/products/index.html.erb"
    And I should have a file "vendor/engines/products/app/views/admin/products/new.html.erb"
    And I should have a file "vendor/engines/products/app/views/admin/products/_product.html.erb"
    And I should have a file "vendor/engines/products/app/views/products/index.html.erb"
    And I should have a file "vendor/engines/products/app/views/products/show.html.erb"