module Refinery
  module Dashboard
    class Engine < Rails::Engine

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_dashboard"
          plugin.url = {:controller => '/admin/dashboard', :action => 'index'}
          plugin.menu_match = /(admin|refinery)\/(refinery_)?dashboard$/
          plugin.directory = "dashboard"
          plugin.version = %q{0.9.8}
          plugin.always_allow_access = true
          plugin.dashboard = true
        end
      end

    end
  end
end
