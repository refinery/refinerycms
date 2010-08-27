require 'rack/cache'
require 'dragonfly'
require 'refinery'

module Refinery
  module Images
    class Engine < Rails::Engine
      initializer 'images-with-dragonfly' do |app|
        app_images = Dragonfly[:images]
        app_images.configure_with(:rmagick)
        app_images.configure_with(:rails) do |c|
          c.datastore.root_path = "#{::Rails.root}/public/system/images"
          c.url_path_prefix = '/system/images'
          c.secret      = 'bawyuebIkEasjibHavry' #TODO: This shouldn't be here!
        end
        app_images.configure_with(:heroku, ENV['S3_BUCKET']) if Refinery.s3_backend

        app_images.define_macro(ActiveRecord::Base, :image_accessor)
        app_images.analyser.register(Dragonfly::Analysis::RMagickAnalyser)
        app_images.analyser.register(Dragonfly::Analysis::FileCommandAnalyser)

        ### Extend active record ###

        app.config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :images, '/system/images'

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
          plugin.directory = "images"
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
