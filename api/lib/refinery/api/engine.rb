module Refinery
  module Api
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Api

      engine_name :refinery_api

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinerycms_api"
          plugin.hide_from_menu = true
          plugin.pathname = root
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Api)
      end
    end
  end
end
