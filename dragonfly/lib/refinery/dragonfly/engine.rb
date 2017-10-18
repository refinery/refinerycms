module Refinery
  module Dragonfly
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_dragonfly

      config.autoload_paths += %W( #{config.root}/lib )

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = "refinerycms_dragonfly"
          plugin.hide_from_menu = true
          plugin.menu_match = %r{refinery/dragonfly}
        end
      end

      config.after_initialize do
        Refinery.register_engine Refinery::Dragonfly
      end

    end
  end
end
