module Refinery
  module Dashboard
    class Engine < Rails::Engine

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.title = "Dashboard"
          plugin.name = "refinery_dashboard"
          plugin.menu_match = /(admin|refinery)\/(refinery_)?dashboard$/
          plugin.description = "Gives an overview of activity in Refinery"
          plugin.directory = "dashboard"
          plugin.version = %q{0.9.8}
          plugin.always_allow_access = true
          plugin.dashboard = true
        end
      end

    end
  end
end
