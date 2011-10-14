require 'refinerycms-images'
require 'rails'

module Refinery
  module Images
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace ::Refinery
      engine_name "refinery_images"

      initializer 'images-with-dragonfly', :before => :load_config_initializers do |app|
        ::Refinery::Images::Dragonfly.setup!
        ::Refinery::Images::Dragonfly.attach!(app)
      end

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_images'
          plugin.directory = 'images'
          plugin.version = %q{2.0.0}
          plugin.menu_match = /refinery\/image(_dialog)?s$/
          plugin.activity = {
            :class => Image
          }
          plugin.url = app.routes.url_helpers.refinery_admin_images_path
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Images)
      end
    end
  end
end
