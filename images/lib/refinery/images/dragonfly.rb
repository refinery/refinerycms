module Refinery
  module Images
    module Dragonfly

      class << self
        def setup!
          app_images = ::Dragonfly[:refinery_images]
          app_images.configure_with(:imagemagick)

          app_images.define_macro(::Refinery::Core::Base, :image_accessor)

          app_images.analyser.register(::Dragonfly::ImageMagick::Analyser)
          app_images.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
        end

        def configure!
          app_images = ::Dragonfly[:refinery_images]
          app_images.configure_with(:rails) do |c|
            c.datastore.root_path = Refinery::Images.datastore_root_path
            c.url_format = Refinery::Images.config.dragonfly_url_format
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
        end

        def attach!(app)
          ### Extend active record ###
          app.config.middleware.insert_before Refinery::Resources.config.dragonfly_insert_before,
                                              'Dragonfly::Middleware', :refinery_images

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
