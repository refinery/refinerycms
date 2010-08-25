require 'refinery'

module Refinery
  module Settings
    class Engine < Rails::Engine
      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.title = "Settings"
          plugin.name = "refinery_settings"
          plugin.url = {:controller => "admin/refinery_settings"}
          plugin.description = "Manage Refinery settings"
          plugin.version = %q{0.9.8}
          plugin.menu_match = /(refinery|admin)\/(refinery_)?settings$/
        end
      end
    end
  end
end
