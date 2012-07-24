require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/form/form_generator'

module Refinery
  describe FormGenerator do
    include GeneratorSpec::TestCase

    temp_dir = Dir.mktmpdir("refinery_rspec_form_test")
    let(:temp_dir) { temp_dir }

    destination temp_dir

    before do
      prepare_destination
      run_generator %w{ rspec_form_test title:string description:text choice:radio another:dropdown enable:checkbox }
    end

    after do
      FileUtils.rm_r(temp_dir)
    end

    specify do
      destination_root.should have_structure {
        directory "vendor" do
          directory "extensions" do
            directory "rspec_form_tests" do
              directory "app" do
                directory "controllers" do
                  directory "refinery" do
                    directory "rspec_form_tests" do
                      directory "admin" do
                        file "rspec_form_tests_controller.rb"
                      end
                      file "rspec_form_tests_controller.rb"
                    end
                  end
                end
                directory "mailers" do
                  directory "refinery" do
                    directory "rspec_form_tests" do
                      file "mailer.rb"
                    end
                  end
                end
                directory "models" do
                  directory "refinery" do
                    directory "rspec_form_tests" do
                      file "rspec_form_test.rb"
                      file "setting.rb"
                    end
                  end
                end
                directory "views" do
                  directory "refinery" do
                    directory "rspec_form_tests" do
                      directory "admin" do
                        directory "rspec_form_tests" do
                          file "_records.html.erb"
                          file "_rspec_form_test.html.erb"
                          file "_submenu.html.erb"
                          file "index.html.erb"
                          file "show.html.erb"
                          file "spam.html.erb"
                        end
                      end
                      directory "rspec_form_tests" do
                        file "new.html.erb"
                        file "thank_you.html.erb"
                      end
                    end
                  end
                end
              end
              directory "db" do
                file "seeds.rb"
              end
              directory "lib" do
                file "refinerycms-rspec_form_tests.rb"
                directory "refinery" do
                  directory "rspec_form_tests" do
                    file "engine.rb"
                  end
                  file "rspec_form_tests.rb"
                end
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
