module Refinery
  module Dragonfly

    class << self

      def configure!(extension)
        ::ActiveRecord::Base.extend ::Dragonfly::Model
        ::ActiveRecord::Base.extend ::Dragonfly::Model::Validations

        ::Dragonfly.app(extension.dragonfly_name).configure do

          datastore :file, {root_path: extension.dragonfly_datastore_root_path}
          plugin extension.dragonfly_plugin if extension.dragonfly_plugin
          secret extension.dragonfly_secret

          if extension.dragonfly_custom_datastore?
            datastore extension.dragonfly_custom_datastore_class.new(extension.dragonfly_custom_datastore_opts)
          end

          url_format extension.dragonfly_url_format
          url_host extension.dragonfly_url_host
          url_path_prefix extension.dragonfly_url_path_prefix

          allow_legacy_urls extension.dragonfly_allow_legacy_urls
          dragonfly_url extension.dragonfly_dragonfly_url
          fetch_file_whitelist extension.dragonfly_fetch_file_whitelist
          fetch_url_whitelist extension.dragonfly_fetch_url_whitelist

          response_header extension.dragonfly_response_header

          verify_urls extension.dragonfly_verify_urls

          #  These options require a name and block
          define_url extension.dragonfly_define_url if extension.dragonfly_define_url.present?
          before_serve(&extension.dragonfly_before_serve) if extension.dragonfly_before_serve.present?


          # There can be more than one instance of each of these options.
          extension.dragonfly_mime_types.each do |mt|
            mime_type mt[:ext], mt[:mimetype]
          end

          extension.dragonfly_analysers.each do |a|
            analyser a[:name], a[:block]
          end unless extension.dragonfly_analysers.blank?

          extension.dragonfly_generators.each do |g|
            generator g[:name], g[:block]
          end unless extension.dragonfly_generators.blank?

          extension.dragonfly_processors.each do |p|
            processor p[:name], p[:block]
          end unless extension.dragonfly_processors.blank?

          if extension.s3_datastore?
            require 'dragonfly/s3_data_store'
            datastore :s3,{
              access_key_id: extension.s3_access_key_id,
              datastore: extension.s3_datastore,
              bucket_name: extension.s3_bucket_name,
              fog_storage_options: extension.s3_fog_storage_options,
              region: extension.s3_region,
              root_path: extension.s3_root_path,
              secret_access_key: extension.s3_secret_access_key,
              storage_path: extension.s3_storage_path,
              storage_headers: extension.s3_storage_headers,
              url_host: extension.s3_url_host,
              url_scheme: extension.s3_url_scheme,
              use_iam_profile: extension.s3_use_iam_profile
            }
          end

        end
      end

      def attach!(app, extension)

        # Injects Dragonfly::Middleware into the stack

        if defined?(::Rack::Cache)
          unless app.config.action_controller.perform_caching && app.config.action_dispatch.rack_cache
            app.config.middleware.insert 0, ::Rack::Cache, {
              verbose: extension.dragonfly_cache_log_level =='verbose',
              metastore: "file:#{extension.dragonfly_cache_store_root}/meta",
              entitystore: "file:#{extension.dragonfly_cache_store_root}/body"
            }
          end
          app.config.middleware.insert_after ::Rack::Cache, ::Dragonfly::Middleware, extension.dragonfly_name
        else
          app.config.middleware.use ::Dragonfly::Middleware, extension.dragonfly_name
        end
      end
    end
  end
end
