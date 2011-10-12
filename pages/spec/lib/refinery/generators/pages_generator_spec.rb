require 'spec_helper'
require "generator_spec/test_case"

module Refinery
  describe PagesGenerator do
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
          directory "seeds" do
            file "pages.rb"
          end
        end
        directory "config" do
          directory "initializers" do
            file "refinery_pages.rb" do
              contains "Refinery::Pages::Options.configure"
            end
          end
        end
      }
    end
  end
end
