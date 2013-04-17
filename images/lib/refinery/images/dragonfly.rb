require 'dragonfly'

module Refinery
  module Images
    module Dragonfly

      class << self
        def setup!
          app_images = ::Dragonfly[:refinery_images]

          app_images.define_macro(::Refinery::Image, :image_accessor)

          app_images.analyser.register(::Dragonfly::ImageMagick::Analyser)
          app_images.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
        end

        def configure!
          app_images = ::Dragonfly[:refinery_images]
          app_images.configure_with(:imagemagick)
          app_images.configure_with(:rails) do |c|
            c.datastore.root_path = Refinery::Images.datastore_root_path
            c.url_format = Refinery::Images.dragonfly_url_format
            c.url_host = Refinery::Images.dragonfly_url_host
            c.secret = Refinery::Images.dragonfly_secret
            c.trust_file_extensions = Refinery::Images.trust_file_extensions
          end

          if ::Refinery::Images.s3_backend
            app_images.datastore = ::Dragonfly::DataStorage::S3DataStore.new
            app_images.datastore.configure do |s3|
              s3.bucket_name = Refinery::Images.s3_bucket_name
              s3.access_key_id = Refinery::Images.s3_access_key_id
              s3.secret_access_key = Refinery::Images.s3_secret_access_key
              # S3 Region otherwise defaults to 'us-east-1'
              s3.region = Refinery::Images.s3_region if Refinery::Images.s3_region
            end
          end

          if ::Refinery::Images.custom_backend
            app_images.datastore = Refinery::Images.custom_backend_class.new(Refinery::Images.custom_backend_opts)
          end
        end

        ##
        # Injects Dragonfly::Middleware for Refinery::Images into the stack
        def attach!(app)
          if ::Rails.application.config.action_controller.perform_caching
            app.config.middleware.insert_after 'Rack::Cache', 'Dragonfly::Middleware', :refinery_images
          else
            app.config.middleware.use 'Dragonfly::Middleware', :refinery_images
          end
        end
      end

    end
  end
end
