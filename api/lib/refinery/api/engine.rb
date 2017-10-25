module Refinery
  module Api
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Api

      engine_name :refinery_api

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "api"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.api_admin_apis_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Api)
      end
    end
  end
end
