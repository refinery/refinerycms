require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/engine/engine_generator'

module Refinery
  describe EngineGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../../../../../tmp", __FILE__)

    before do
      prepare_destination
      run_generator %w{ rspec_product_test title:string description:text image:image brochure:resource }
    end

    it "uses reference columns for image and resource attributes" do
      File.open("#{destination_root}/vendor/extensions/rspec_product_tests/app/controllers/refinery/rspec_product_tests/admin/rspec_product_tests_controller.rb") do |file|
        content = file.read
        expect(content.include?('image_id')).to be_truthy
        expect(content.include?('brochure_id')).to be_truthy
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
                          file "_actions.html.erb"
                          file "_form.html.erb"
                          file "_records.html.erb"
                          file "_rspec_product_test.html.erb"
                          file "_rspec_product_tests.html.erb"
                          file "_sortable_list.html.erb"
                          file "edit.html.erb"
                          file "index.html.erb"
                          file "new.html.erb"
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
              directory "config" do
                directory "locales" do
                  file "cs.yml"
                  file "en.yml"
                  file "es.yml"
                  file "fr.yml"
                  file "it.yml"
                  file "nb.yml"
                  file "nl.yml"
                  file "sk.yml"
                  file "tr.yml"
                  file "zh-CN.yml"
                end
                file "routes.rb"
              end
              directory "db" do
                directory "migrate" do
                  file "1_create_rspec_product_tests_rspec_product_tests.rb"
                end
                file "seeds.rb"
              end
              directory "lib" do
                directory "generators" do
                  directory "refinery" do
                    file "rspec_product_tests_generator.rb"
                  end
                end
                directory "refinery" do
                  directory "rspec_product_tests" do
                    file "engine.rb"
                  end
                  file "rspec_product_tests.rb"
                end
                directory "tasks" do
                  directory "refinery" do
                    file "rspec_product_tests.rake"
                  end
                end
                file "refinerycms-rspec_product_tests.rb"
              end
              directory "script" do
                file "rails"
              end
              directory "spec" do
                directory "features" do
                  directory "refinery" do
                    directory "rspec_product_tests" do
                      directory "admin" do
                        file "rspec_product_tests_spec.rb"
                      end
                    end
                  end
                end
                directory "models" do
                  directory "refinery" do
                    directory "rspec_product_tests" do
                      file "rspec_product_test_spec.rb"
                    end
                  end
                end
                directory "support" do
                  directory "factories" do
                    directory "refinery" do
                      file "rspec_product_tests.rb"
                    end
                  end
                end
                file "spec_helper.rb"
              end
              directory "tasks" do
                file "testing.rake"
                file "rspec.rake"
              end
              file "Gemfile"
              file "Rakefile"
              file "readme.md"
              file "refinerycms-rspec_product_tests.gemspec"
            end
          end
        end
      }
    end
  end
end
