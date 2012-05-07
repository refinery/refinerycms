require 'dragonfly'

module Refinery
  module Resources
    module Dragonfly

      class << self
        def setup!
          app_resources = ::Dragonfly[:refinery_resources]

          app_resources.define_macro(::Refinery::Resource, :resource_accessor)

          app_resources.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
          app_resources.content_disposition = :attachment
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

        def attach!(app)
          ### Extend active record ###
          app.config.middleware.insert_before Refinery::Resources.dragonfly_insert_before,
                                              'Dragonfly::Middleware', :refinery_resources

          app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
            :verbose     => Refinery::Core.verbose_rack_cache,
            :metastore   => "file:#{URI.encode(Rails.root.join('tmp', 'dragonfly', 'cache', 'meta').to_s)}",
            :entitystore => "file:#{URI.encode(Rails.root.join('tmp', 'dragonfly', 'cache', 'body').to_s)}"
          }
        end
      end

    end
  end
end
