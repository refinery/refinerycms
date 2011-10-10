require 'spec_helper'
require "generator_spec/test_case"

module Refinery
  describe Generators::TestingGenerator do
    include GeneratorSpec::TestCase
    
    destination File.expand_path("../../../../../tmp/vendor/engines/rspec_engine_tests", __FILE__)

    before(:each) do
      prepare_destination
      quietly do
        args = %w{ rspec_engine_test title:string description:text image:image brochure:resource }
        Refinery::Generators::EngineGenerator.new(args, { :force => true }, 
          { :destination_root => File.expand_path("../../../../../tmp", __FILE__) }
        ).generate
      end
      
      run_generator
    end
    
    specify :focus => true do
      destination_root.should have_structure {
        directory "spec" do
          directory "dummy" do
            directory "db" do
              directory "seeds"
              file "seeds.rb"
            end
          end
        end
      }
    end
  end
end
