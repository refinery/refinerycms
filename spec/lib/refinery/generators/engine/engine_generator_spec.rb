require 'spec_helper'
require "generator_spec/test_case"

module Refinery
  describe Generators::EngineGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../tmp", __FILE__)
    
    before(:each) do
      prepare_destination
      run_generator %w{ rspec_product_test title:string description:text image:image brochure:resource }
    end
    
    specify do
      destination_root.should have_structure {
        directory "vendor" do
          directory "engines" do
            directory "rspec_product_tests" do
              directory "app" do
                directory "controllers" do
                  directory "refinery" do
                    directory "admin" do
                      file "rspec_product_tests_controller.rb"
                    end
                    file "rspec_product_tests_controller.rb"
                  end
                end
                directory "models" do
                  directory "refinery" do
                    file "rspec_product_test.rb"
                  end
                end
                directory "views" do
                  directory "refinery" do
                    directory "admin" do
                      directory "rspec_product_tests" do
                        file "_form.html.erb"
                        file "_sortable_list.html.erb"
                        file "edit.html.erb"
                        file "index.html.erb"
                        file "new.html.erb"
                        file "_rspec_product_test.html.erb"
                      end
                    end
                    directory "rspec_product_tests" do
                      file "index.html.erb"
                      file "show.html.erb"
                    end
                  end
                end
              end
              directory "lib" do
                file "refinerycms-rspec_product_tests.rb"
              end
              directory "config" do
                directory "locales" do
                  file "en.yml"
                end
                file "routes.rb"
              end
            end
          end
        end
      }
    end
  end
end
