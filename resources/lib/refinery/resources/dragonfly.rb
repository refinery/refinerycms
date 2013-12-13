require 'dragonfly'

module Refinery
  module Resources
    module Dragonfly

      class << self
        def setup!
          app_resources = ::Dragonfly.app(:refinery_resources)
          app_resources.configure do
            analyser ::Dragonfly::Analysis::FileCommandAnalyser
            content_disposition Refinery::Resources.content_disposition
          end
        end

        def configure!
          app_resources = ::Dragonfly.app(:refinery_resources)
          # app_resources.configure_with(:rails)
          app_resources.configure do
            datastore :file, {
              root_path: Refinery::Resources.datastore_root_path,
              server_root: Rails.root.join('public')
            }
          end

          # Configure
          app_resources.configure do
            protect_from_dos_attacks false

            url_format Refinery::Resources.dragonfly_url_format
            url_host Refinery::Resources.dragonfly_url_host
            secret Refinery::Resources.dragonfly_secret
          end

          if ::Refinery::Resources.s3_backend
            require 'dragonfly/s3_data_store'
            options = {
              bucket_name: Refinery::Resources.s3_bucket_name,
              access_key_id: Refinery::Resources.s3_access_key_id,
              secret_access_key: Refinery::Resources.s3_secret_access_key
            }
            options.update(region: Refinery::Resources.s3_region) if Refinery::Resources.s3_region
            app_resources.datastore :s3, options
          end

          if Resources.custom_backend?
            app_resources.datastore = Resources.custom_backend_class.new(Resources.custom_backend_opts)
          end
        end

        ##
        # Injects Dragonfly::Middleware for Refinery::Images into the stack
        def attach!(app)
          if defined?(::Rack::Cache)
            unless app.config.action_controller.perform_caching && app.config.action_dispatch.rack_cache
              app.config.middleware.insert 0, ::Rack::Cache, {
                verbose: true,
                metastore: URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/meta"), # URI encoded in case of spaces
                entitystore: URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/body")
              }
            end
            app.config.middleware.insert_after ::Rack::Cache, ::Dragonfly::Middleware, :refinery_resources
          else
            app.config.middleware.use ::Dragonfly::Middleware, :refinery_resources
          end
        end
      end

    end
  end
end
