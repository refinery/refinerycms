module Refinery
  module Storage

    class << self

      def configure!(extension)
        ::ActiveRecord::Base.extend ::Storage::Model
        ::ActiveRecord::Base.extend ::Storage::Model::Validations

        ::Storage.app(extension.storage_name).configure do

          datastore :file, {root_path: extension.storage_datastore_root_path}
          plugin extension.storage_plugin if extension.storage_plugin
          secret extension.storage_secret

          if extension.storage_custom_datastore?
            datastore extension.storage_custom_datastore_class.new(extension.storage_custom_datastore_opts)
          end

          url_format extension.storage_url_format
          url_host extension.storage_url_host
          url_path_prefix extension.storage_url_path_prefix

          allow_legacy_urls extension.storage_allow_legacy_urls
          storage_url extension.storage_storage_url
          fetch_file_whitelist extension.storage_fetch_file_whitelist
          fetch_url_whitelist extension.storage_fetch_url_whitelist

          response_header extension.storage_response_header

          verify_urls extension.storage_verify_urls

          #  These options require a name and block
          define_url extension.storage_define_url if extension.storage_define_url.present?
          before_serve extension.storage_before_serve if extension.storage_before_serve.present?


          # There can be more than one instance of each of these options.
          extension.storage_mime_types.each do |mt|
            mime_type mt[:ext], mt[:mimetype]
          end

          extension.storage_analysers.each do |a|
            analyser a[:name], a[:block]
          end unless extension.storage_analysers.blank?

          extension.storage_generators.each do |g|
            generator g[:name], g[:block]
          end unless extension.storage_generators.blank?

          extension.storage_processors.each do |p|
            processor p[:name], p[:block]
          end unless extension.storage_processors.blank?

          if extension.s3_datastore
            require 'storage/s3_data_store'
            datastore :s3,{
              s3_access_key_id: extension.s3_access_key_id,
              s3_datastore: extension.s3_datastore,
              s3_bucket_name: extension.s3_bucket_name,
              s3_fog_storage_options: extension.s3_fog_storage_options,
              s3_region: extension.s3_region,
              s3_root_path: extension.s3_root_path,
              s3_secret_access_key: extension.s3_secret_access_key,
              s3_storage_path: extension.s3_storage_path,
              s3_storage_headers: extension.s3_storage_headers,
              s3_url_host: extension.s3_url_host,
              s3_url_scheme: extension.s3_url_scheme,
              s3_use_iam_profile: extension.s3_use_iam_profile
            }
          end

        end
      end

      def attach!(app, extension)

        # Injects Storage::Middleware into the stack

        if defined?(::Rack::Cache)
          unless app.config.action_controller.perform_caching && app.config.action_dispatch.rack_cache
            app.config.middleware.insert 0, ::Rack::Cache, {
              verbose: extension.storage_cache_log_level =='verbose',
              metastore: URI.encode("file:#{extension.storage_cache_store_root}/meta"), # URI encoded in case of spaces
              entitystore: URI.encode("file:#{extension.storage_cache_store_root}/body")
            }
          end
          app.config.middleware.insert_after ::Rack::Cache, ::Storage::Middleware, extension.storage_name
        else
          app.config.middleware.use ::Storage::Middleware, extension.storage_name
        end
      end
    end
  end
end
