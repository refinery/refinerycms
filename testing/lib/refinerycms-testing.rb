require 'refinerycms-core'
require 'refinery/generators/testing_generator'

module Refinery
  module Testing
    autoload :ControllerMacros, 'refinery/testing/controller_macros'
    autoload :RequestMacros, 'refinery/testing/request_macros'

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
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
