require 'rack/cache'
require 'dragonfly'
require 'refinery'

module Refinery
  module Images
    class Engine < Rails::Engine
      initializer 'images-with-dragonfly' do |app|
        require 'dragonfly'
        app_images = Dragonfly[:images]
        app_images.configure_with(:rails) do |c|
          c.datastore.root_path = "#{::Rails.root}/public/system/images"
          c.path_prefix = '/system/images'
          #TODO: Shouldn't this secret be placed somewhere in a initializer, to make sure it scopes to only one project, and not all refinery setups?
          c.secret      = 'bawyuebIkEasjibHavry'
        end
        app_images.configure_with(:rmagick)

        ### Extend active record ###
        app_images.define_macro(ActiveRecord::Base, :image_accessor)

        app.config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :images

        app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
          :verbose     => true,
          :metastore   => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
          :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
        }
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_images"
          plugin.directory = "images"
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
