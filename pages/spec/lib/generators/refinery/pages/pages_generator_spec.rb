require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/pages/pages_generator'

module Refinery
  describe PagesGenerator do
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
              file "pages.rb" do
                contains "Refinery::Pages.configure"
              end
            end
          end
        end
      }
    end
  end
end
