require 'refinerycms-base'
require File.expand_path('../generators/settings_generator', __FILE__)

module Refinery
  module Settings

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_settings'
          plugin.url = app.routes.url_helpers.refinery_admin_settings_path
          plugin.version = %q{2.0.0}
          plugin.menu_match = /refinery\/settings$/
        end
      end
    end
  end
end

::Refinery.engines << 'settings'
