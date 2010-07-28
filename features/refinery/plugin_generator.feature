Feature: Plugin generation
  In order to create my own plugin
  As a refinery user
  I want to generate a basic plugin directory structure

  Scenario: Generating a plugin with a name
    Given I have a refinery application
    When I generate a plugin with the arguments of "product title:string description:text image:image brochure:resource"
    Then I should have a directory "vendor/plugins/products"
    And I should have a directory "vendor/plugins/products/app"
    And I should have a directory "vendor/plugins/products/config"
    And I should have a directory "vendor/plugins/products/rails"
    And I should have a directory "vendor/plugins/products/rails"
    And I should have a file "vendor/plugins/products/rails/init.rb"
    And I should have a file "vendor/plugins/products/app/controllers/admin/products_controller.rb"
    And I should have a file "vendor/plugins/products/app/controllers/products_controller.rb"
    And I should have a file "vendor/plugins/products/app/models/product.rb"
    And I should have a file "vendor/plugins/products/config/routes.rb"
    And I should have a file "vendor/plugins/products/config/locales/en.yml"
    And I should have a file "vendor/plugins/products/app/views/admin/products/_form.html.erb"
    And I should have a file "vendor/plugins/products/app/views/admin/products/_sortable_list.html.erb"
    And I should have a file "vendor/plugins/products/app/views/admin/products/edit.html.erb"
    And I should have a file "vendor/plugins/products/app/views/admin/products/index.html.erb"
    And I should have a file "vendor/plugins/products/app/views/admin/products/new.html.erb"
    And I should have a file "vendor/plugins/products/app/views/admin/products/_product.html.erb"
    And I should have a file "vendor/plugins/products/app/views/products/index.html.erb"
    And I should have a file "vendor/plugins/products/app/views/products/show.html.erb"