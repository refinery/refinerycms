require 'refinerycms-dashboard'
require 'rails'

module Refinery
  module Dashboard
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_dashboard'
          plugin.url = app.routes.url_helpers.refinery_admin_dashboard_path
          plugin.menu_match = /refinery\/(refinery_)?dashboard$/
          plugin.directory = 'dashboard'
          plugin.version = %q{2.0.0}
          plugin.always_allow_access = true
          plugin.dashboard = true
        end
      end

      config.after_initialize do
        ::Refinery.engines << 'dashboard'
      end
    end
  end
end
