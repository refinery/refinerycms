require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/core/core_generator'

module Refinery
  describe CoreGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../../../../tmp", __FILE__)

    before do
      prepare_destination
      run_generator
    end

    specify do
      expect(destination_root).to have_structure {
        directory "config" do
          directory "initializers" do
            directory "refinery" do
              file "core.rb" do
                contains "Refinery::Core.configure do |config|"
              end
            end
          end
        end
      }
    end
  end
end
