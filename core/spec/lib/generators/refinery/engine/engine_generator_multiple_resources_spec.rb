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

    context "when generating a resource inside existing extensions dir" do

      before do
        run_generator %w{ rspec_item_test title:string --extension rspec_product_tests --namespace rspec_product_tests --skip }
      end

      it "creates a new migration with the new resource" do
        destination_root.should have_structure {
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
    end

  end
end
