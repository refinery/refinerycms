module Refinery
  module Storage
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_storage

      config.autoload_paths += %W( #{config.root}/lib )

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = "refinerycms_storage"
          plugin.hide_from_menu = true
          plugin.menu_match = %r{refinery/storage}
        end
      end

      config.after_initialize do
        Refinery.register_engine Refinery::Storage
      end

    end
  end
end
