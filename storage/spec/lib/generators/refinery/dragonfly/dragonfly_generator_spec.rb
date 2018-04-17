require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/dragonfly/dragonfly_generator'

module Refinery
  describe DragonflyGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../../../tmp", __FILE__)

    before do
      prepare_destination
      run_generator %w[--skip-migrations]
    end

    specify do
      expect(destination_root).to have_structure {
        directory "config" do
          directory "initializers" do
            directory "refinery" do
              file "dragonfly.rb" do
                contains "Refinery::Dragonfly.configure"
              end
            end
          end
        end
      }
    end
  end
end
