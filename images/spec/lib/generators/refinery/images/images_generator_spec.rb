require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/images/images_generator'

module Refinery
  describe ImagesGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../../../tmp", __FILE__)

    before(:each) do
      prepare_destination
      run_generator
    end

    specify do
      destination_root.should have_structure {
        directory "config" do
          directory "initializers" do
            file "refinery_images.rb" do
              contains "Refinery::Images.configure"
            end
          end
        end
      }
    end
  end
end
