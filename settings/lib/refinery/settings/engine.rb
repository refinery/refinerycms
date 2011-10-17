require 'refinerycms-settings'
require 'rails'

module Refinery
  module Settings
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :settings

      initializer "register refinery_settings plugin", :after => :set_routes_reloader do |app|
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_settings'
          plugin.url = app.routes.url_helpers.refinery_admin_settings_path
          plugin.version = %q{2.0.0}
          plugin.menu_match = /refinery\/settings$/
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Settings)
      end
    end
  end
end
