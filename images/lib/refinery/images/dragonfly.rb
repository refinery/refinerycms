module Refinery
  module Images
    module Dragonfly

      class << self
        def setup!
          app_images = ::Dragonfly[:images]
          app_images.configure_with(:imagemagick)
          app_images.configure_with(:rails) do |c|
            c.datastore.root_path = Rails.root.join('public', 'system', 'images').to_s
            # This url_format it so that dragonfly urls work in traditional
            # situations where the filename and extension are required, e.g. lightbox.
            # What this does is takes the url that is about to be produced e.g.
            # /system/images/BAhbB1sHOgZmIiMyMDEwLzA5LzAxL1NTQ19DbGllbnRfQ29uZi5qcGdbCDoGcDoKdGh1bWIiDjk0MngzNjAjYw
            # and adds the filename onto the end (say the image was 'refinery_is_awesome.jpg')
            # /system/images/BAhbB1sHOgZmIiMyMDEwLzA5LzAxL1NTQ19DbGllbnRfQ29uZi5qcGdbCDoGcDoKdGh1bWIiDjk0MngzNjAjYw/refinery_is_awesome.jpg
            c.url_format = '/system/images/:job/:basename.:format'
            c.secret = Refinery::Images.config.dragonfly_secret
          end

          if ::Refinery::Images.config.s3_backend
            app_images.datastore = Dragonfly::DataStore::S3DataStore.new
            app_images.datastore.configure do |s3|
              s3.bucket_name = Refinery::Images.config.s3_bucket_name
              s3.access_key_id = Refinery::Images.config.s3_access_key_id
              s3.secret_access_key = Refinery::Images.config.s3_secret_access_key
              # S3 Region otherwise defaults to 'us-east-1'
              s3.region = Refinery::Images.config.s3_region if Refinery::Images.config.s3_region
            end
          end

          app_images.define_macro(::ActiveRecord::Base, :image_accessor)
          app_images.analyser.register(::Dragonfly::ImageMagick::Analyser)
          app_images.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
        end

        def attach!(app)
          ### Extend active record ###
          app.config.middleware.insert_before Refinery::Resources.config.dragonfly_insert_before,
                                              'Dragonfly::Middleware', :images

          app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
            :verbose     => Rails.env.development?,
            :metastore   => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
            :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
          }
        end
      end

    end
  end
end
