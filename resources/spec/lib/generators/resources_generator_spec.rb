require 'spec_helper'
require "generator_spec/test_case"

module Refinery
  describe ResourcesGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../tmp", __FILE__)
    
    before(:each) do
      prepare_destination
      run_generator
    end
    
    specify do
      destination_root.should have_structure {
        directory "config" do
          file "refinery_resource_config.yml" do
            contains "max_client_body_size:"
          end
        end
      }
    end
  end
end
