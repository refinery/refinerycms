require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/engine/engine_generator'

module Refinery
  describe EngineGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../../../../../tmp", __FILE__)

    before do
      prepare_destination
      run_generator %w{ rspec_product_test title:string description:text image:image brochure:resource --authors Author1 Author2 }
    end

    it "uses reference columns for image and resource attributes" do
      File.open("#{destination_root}/vendor/extensions/rspec_product_tests/refinerycms-rspec_product_tests.gemspec") do |file|
        content = file.read
        expect(content.include?('["Author1", "Author2"]')).to be_truthy
      end
    end

    specify do
      expect(destination_root).to have_structure {
        directory "vendor" do
          directory "extensions" do
            directory "rspec_product_tests" do
              directory "app" do
                directory "controllers" do
                  directory "refinery" do
                    directory "rspec_product_tests" do
                      directory "admin" do
                        file "rspec_product_tests_controller.rb"
                      end
                      file "rspec_product_tests_controller.rb"
                    end
                  end
                end
                directory "models" do
                  directory "refinery" do
                    directory "rspec_product_tests" do
                      file "rspec_product_test.rb"
                    end
                  end
                end
                directory "views" do
                  directory "refinery" do
                    directory "rspec_product_tests" do
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
              end
              directory "lib" do
                file "refinerycms-rspec_product_tests.rb"
              end
              directory "spec" do
                file "spec_helper.rb"
              end
              directory "tasks" do
                file "testing.rake"
                file "rspec.rake"
              end
              directory "config" do
                directory "locales" do
                  file "en.yml"
                end
                file "routes.rb"
              end
              file "Gemfile"
              file "Rakefile"
            end
          end
        end
      }
    end
  end
end
