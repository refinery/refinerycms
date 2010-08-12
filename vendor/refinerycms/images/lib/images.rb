require 'rack/cache'
require 'refinery'

module Refinery
  module Images
    class Engine < Rails::Engine
      initializer 'images-with-dragonfly' do |app|
        app.config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :images

        app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
          :verbose     => true,
          :metastore   => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
          :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
        }
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.title = "Images"
          plugin.name = "refinery_images"
          plugin.description = "Manage images"
          plugin.version = %q{0.9.8}
          plugin.menu_match = /(refinery|admin)\/image(_dialog)?s$/
          plugin.activity = {
            :class => Image
          }
        end
      end
    end
  end
end
