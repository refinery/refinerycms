require 'refinerycms-core'
require 'refinery/generators/testing_generator'
require 'factory_girl_rails'

module Refinery
  module Testing    
    autoload :ControllerMacros, 'refinery/testing/controller_macros'
    autoload :RequestMacros, 'refinery/testing/request_macros'

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

    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery
      
      config.after_initialize do
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinerycms_testing_plugin'
          plugin.version = ::Refinery.version
          plugin.hide_from_menu = true
        end
      end
    end
  end
end

::Refinery.engines << 'testing'
