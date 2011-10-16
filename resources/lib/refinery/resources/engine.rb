require 'refinerycms-resources'
require 'rails'

module Refinery
  module Resources
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace ::Refinery
      engine_name :refinery_resources

      initializer 'resources-with-dragonfly', :before => :load_config_initializers do |app|
        ::Refinery::Resources::Dragonfly.setup!
        ::Refinery::Resources::Dragonfly.attach!(app)
      end

      initializer "register refinery_files plugin", :after => :set_routes_reloader do |app|
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_files'
          plugin.url = app.routes.url_helpers.refinery_admin_resources_path
          plugin.menu_match = /refinery\/(refinery_)?(files|resources)$/
          plugin.version = %q{2.0.0}
          plugin.activity = {
            :class => Refinery::Resource
          }
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Resources)
      end
    end
  end
end
