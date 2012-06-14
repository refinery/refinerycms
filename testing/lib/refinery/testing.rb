require 'refinerycms-core'
require 'rspec-rails'
require 'factory_girl_rails'

module Refinery
  autoload :TestingGenerator, 'generators/refinery/testing/testing_generator'

  module Testing
    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      # Load the factories of all currently loaded extensions
      def load_factories
        Refinery.extensions.each do |extension_const|
          if extension_const.respond_to?(:factory_paths)
            extension_const.send(:factory_paths).each do |path|
              FactoryGirl.definition_file_paths << path
            end
          end
        end
        FactoryGirl.find_definitions
      end
    end

    require 'refinery/testing/railtie'

    autoload :ControllerMacros, 'refinery/testing/controller_macros'
    autoload :RequestMacros, 'refinery/testing/request_macros'
  end
end
