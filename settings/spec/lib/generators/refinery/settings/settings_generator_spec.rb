require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/settings/settings_generator'

module Refinery
  describe SettingsGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../../../tmp", __FILE__)

    before(:each) do
      prepare_destination
      run_generator
    end

    specify do
      destination_root.should have_structure {
        directory "db" do
          directory "migrate"
        end
      }
    end
  end
end
