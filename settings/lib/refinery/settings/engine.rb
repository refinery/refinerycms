require 'rails'

module Refinery
  module Settings
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_settings

      config.autoload_paths += %W( #{config.root}/lib )

      initializer "register refinery_settings plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_settings'
          plugin.url = {:controller => '/refinery/admin/settings'}
          plugin.version = %q{2.0.0}
          plugin.menu_match = %r{refinery/settings$}
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Settings)
      end
    end
  end
end
