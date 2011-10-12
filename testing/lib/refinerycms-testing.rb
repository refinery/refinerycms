require 'refinerycms-core'
require 'factory_girl_rails'

module Refinery
  module Testing
    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end

      # Load the factories of all currently loaded engines
      def load_factories
        Refinery.engines.each do |engine|
          engine_const = "Refinery::#{engine.camelize}".constantize
          if engine_const.respond_to?(:factory_paths)
            engine_const.send(:factory_paths).each do |path|
              FactoryGirl.definition_file_paths << path
            end
          end
        end
        FactoryGirl.find_definitions
      end
    end
    
    require 'refinery/testing/railtie' if defined?(Rails)
    require 'refinery/generators/testing_generator'

    autoload :ControllerMacros, 'refinery/testing/controller_macros'
    autoload :RequestMacros, 'refinery/testing/request_macros'
  end
end
