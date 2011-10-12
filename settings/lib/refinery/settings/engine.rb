require 'refinerycms-settings'
require 'rails'

module Refinery
  module Settings
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
      
      config.after_initialize do
        Refinery.engines << 'settings'
      end
    end
  end
end
