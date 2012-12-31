require 'dragonfly'

module Refinery
  module Resources
    module Dragonfly

      class << self
        def setup!
          app_resources = ::Dragonfly[:refinery_resources]

          app_resources.define_macro(::Refinery::Resource, :resource_accessor)

          app_resources.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
          app_resources.content_disposition = Refinery::Resources.content_disposition
        end

        def configure!
          app_resources = ::Dragonfly[:refinery_resources]
          app_resources.configure_with(:rails) do |c|
            c.datastore.root_path = Refinery::Resources.datastore_root_path
            c.url_format = Refinery::Resources.dragonfly_url_format
            c.secret = Refinery::Resources.dragonfly_secret
          end

          if ::Refinery::Resources.s3_backend
            app_resources.datastore = ::Dragonfly::DataStorage::S3DataStore.new
            app_resources.datastore.configure do |s3|
              s3.bucket_name = Refinery::Resources.s3_bucket_name
              s3.access_key_id = Refinery::Resources.s3_access_key_id
              s3.secret_access_key = Refinery::Resources.s3_secret_access_key
              # S3 Region otherwise defaults to 'us-east-1'
              s3.region = Refinery::Resources.s3_region if Refinery::Resources.s3_region
            end
          end
        end

        ##
        # Injects Dragonfly::Middleware for Refinery::Images into the stack
        def attach!(app)
          if ::Rails.application.config.action_controller.perform_caching
            app.config.middleware.insert_after 'Rack::Cache', 'Dragonfly::Middleware', :refinery_resources
          else
            app.config.middleware.use 'Dragonfly::Middleware', :refinery_resources
          end
        end
      end

    end
  end
end
