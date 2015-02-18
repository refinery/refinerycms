require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/engine/engine_generator'
require 'tmpdir'

module Refinery
  describe EngineGenerator do
    include GeneratorSpec::TestCase
    destination Dir.mktmpdir

    before do
      prepare_destination
      run_generator %w{ rspec_product_test title:string description:text image:image brochure:resource }
    end

    context "when generating a resource without passing a namespace" do
      before do
        run_generator %w{ rspec_item_test title:string --extension rspec_product_tests --skip }
      end

      it "uses the extension name for the namespace" do
        expect(destination_root).to have_structure {
          directory "vendor" do
            directory "extensions" do
              directory "rspec_product_tests" do
                directory "app" do
                  directory "controllers" do
                    directory "refinery" do
                      directory "rspec_product_tests" do
                        file "rspec_item_tests_controller.rb"
                      end
                    end
                  end
                end
              end
            end
          end
        }
      end
    end

    context "when generating a resource inside existing extensions dir" do

      before do
        run_generator %w{ rspec_item_test title:string --extension rspec_product_tests --namespace rspec_product_tests --skip }
      end

      it "creates a new migration with the new resource" do
        expect(destination_root).to have_structure {
          directory "vendor" do
            directory "extensions" do
              directory "rspec_product_tests" do
                directory "db" do
                  directory "migrate" do
                    file "2_create_rspec_product_tests_rspec_item_tests.rb"
                  end
                end
              end
            end
          end
        }
      end

      it "appends existing seeds file" do
        File.open("#{destination_root}/vendor/extensions/rspec_product_tests/db/seeds.rb") do |file|
          expect(file.grep(%r{/rspec_product_tests|/rspec_item_tests}).count).to eq(2)
        end
      end

      it "appends routes to the routes file" do
        File.open("#{destination_root}/vendor/extensions/rspec_product_tests/config/routes.rb") do |file|
          expect(file.grep(%r{rspec_item_tests}).count).to eq(2)
        end
      end
    end
  end
end
