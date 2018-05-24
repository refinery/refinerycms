require 'spec_helper'
require 'fileutils'
require 'generator_spec/test_case'
require 'generators/refinery/engine/engine_generator'

module Refinery
  describe EngineGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../../../../../tmp", __FILE__)
    let(:extension_root){"#{destination_root}/vendor/extensions/rspec_product_tests"}

    before do
      prepare_destination
      run_generator %w{ rspec_product_test title:string description:text image:image brochure:resource }
    end

    after do
      FileUtils.rm_r destination_root
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

      it "does not namespace the link_url in the extension controller" do
        File.read("#{extension_root}/app/controllers/refinery/rspec_product_tests/rspec_product_tests_controller.rb") do |file|
          expect(file.grep(%r{/:link_url => "/rspec_product_tests"\)\.first/})).to be_truthy
        end
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
        File.open("#{extension_root}/db/seeds.rb") do |file|
          expect(file.grep(%r{/rspec_product_tests|/rspec_item_tests}).count).to eq(2)
        end
      end

      it "appends routes to the routes file" do
        File.open("#{extension_root}/config/routes.rb") do |file|
          expect(file.grep(%r{rspec_item_tests}).count).to eq(2)
        end
      end

      it "places second and subsequent routes before the primary extension routes" do
        content = File.read("#{extension_root}/config/routes.rb")
        item_front_end_route = content.index("resources :rspec_item_tests, :only => [:index, :show]")
        product_front_end_route =  content.index("resources :rspec_product_tests, :path => '', :only => [:index, :show]")
        expect(item_front_end_route).to be < product_front_end_route
      end

      it "uses the namespaced url in the extension controller" do
        content = File.read("#{extension_root}/app/controllers/refinery/rspec_product_tests/rspec_item_tests_controller.rb") do |file|
          expect(file.grep(%r{/:link_url => "/rspec_product_tests/rspec_item_tests"\)\.first/})).to be_truthy
        end
      end
    end
  end
end
