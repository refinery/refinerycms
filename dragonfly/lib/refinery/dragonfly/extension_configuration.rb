module Refinery
  module Dragonfly
    module ExtensionConfiguration
      include ActiveSupport::Configurable

      config_accessor :dragonfly_allow_legacy_urls, :dragonfly_analysers,
                      :dragonfly_before_serve,
                      :dragonfly_cache_store_root, :dragonfly_cache_log_level,
                      :dragonfly_custom_datastore_class, :dragonfly_custom_datastore_opts,
                      :dragonfly_datastore_root_path, :dragonfly_define_url, :dragonfly_dragonfly_url,
                      :dragonfly_fetch_file_whitelist, :dragonfly_fetch_url_whitelist,
                      :dragonfly_generators,
                      :dragonfly_mime_types,
                      :dragonfly_name,
                      :dragonfly_path_prefix, :dragonfly_plugin, :dragonfly_processors,
                      :dragonfly_response_header,
                      :dragonfly_secret,
                      :dragonfly_url_format, :dragonfly_url_host, :dragonfly_url_path_prefix, :dragonfly_url_segment,
                      :dragonfly_verify_urls,

                      :s3_access_key_id,
                      :s3_datastore, :s3_bucket_name,
                      :s3_fog_storage_options,
                      :s3_region, :s3_root_path,
                      :s3_secret_access_key, :s3_storage_path, :s3_storage_headers,
                      :s3_url_host, :s3_url_scheme, :s3_use_iam_profiles


        def short_name
          config.dragonfly_name.to_s.remove('refinery_')
        end

        def dragonfly_allow_legacy_urls
          config.dragonfly_allow_legacy_urls.presence || Refinery::Dragonfly.allow_legacy_urls
        end

        def dragonfly_analysers
          config.dragonfly_analysers.presence || Refinery::Dragonfly.analysers
        end

        def dragonfly_before_serve
          config.dragonfly_before_serve.presence || Refinery::Dragonfly.before_serve
        end

        def dragonfly_cache_store_root
          config.dragonfly_cache_store.presence || Rails.root.join('tmp', 'dragonfly')
        end

        def dragonfly_cache_log_level
          config.dragonfly_cache_log_level || Refinery::Dragonfly.cache_log_level
        end

        def dragonfly_custom_datastore?
          config.dragonfly_custom_datastore_class.nil? ? Refinery::Dragonfly.custom_datastore? : config.custom_datastore_class.present?
        end

        def dragonfly_custom_datastore_class
          config.dragonfly_custom_datastore_class.nil? ? Refinery::Dragonfly.custom_datastore_class : config.dragonfly_custom_datastore_class.constantize
        end

        def dragonfly_custom_datastore_opts
          config.dragonfly_custom_datastore_opts.presence || Refinery::Dragonfly.custom_datastore_opts
        end

        def dragonfly_datastore_root_path
          config.dragonfly_datastore_root_path.presence || Rails.root.join('public', 'system', 'refinery', short_name).to_s if Rails.root
        end

        def dragonfly_define_url
          config.dragonfly_define_url || Refinery::Dragonfly.define_url
        end

        def dragonfly_dragonfly_url
          config.dragonfly_dragonfly_url || Refinery::Dragonfly.dragonfly_url
        end

        def dragonfly_fetch_file_whitelist
          config.dragonfly_fetch_file_whitelist || Refinery::Dragonfly.fetch_file_whitelist
        end

        def dragonfly_fetch_url_whitelist
          config.dragonfly_fetch_url_whitelist || Refinery::Dragonfly.fetch_url_whitelist
        end

        def dragonfly_generators
          config.dragonfly_generators || Refinery::Dragonfly.generators
        end


        # define one or more new mimetypes
        # dragonfly_mimetypes = [
        #   {ext: 'egg', mimetype: 'fried/egg'},
        #   {ext: 'avo', mimetype: 'smashed/avo'}
        # ]
        #

        def dragonfly_mime_types
          config.dragonfly_mime_types || Refinery::Dragonfly.mime_types
        end

        def dragonfly_name
          config.dragonfly_name || Refinery::Dragonfly.name
        end

        def dragonfly_path_prefix
          config.dragonfly_path_prefix || Refinery::Dragonfly.path_prefix
        end

        def dragonfly_response_header
          config.dragonfly_response_header || Refinery::Dragonfly.response_header
        end

        def dragonfly_secret
          config.dragonfly_secret || Refinery::Dragonfly.secret
        end

        def dragonfly_url
          config.dragonfly_url || Refinery::Dragonfly.url
        end

        def dragonfly_url_format
          config.dragonfly_url_format || Refinery::Dragonfly.url_format(short_name)
        end

        def dragonfly_url_host
          config.dragonfly_url_host || Refinery::Dragonfly.url_host
        end

        def dragonfly_url_path_prefix
          config.dragonfly_url_path_prefix || Refinery::Dragonfly.url_path_prefix
        end

        def dragonfly_url_segment
          config.dragonfly_url_segment || short_name
        end

        def dragonfly_verify_urls
          config.dragonfly_verify_urls.nil? ? Refinery::Dragonfly.verify_urls : config.dragonfly_verify_urls
        end

        # -------------------
        # Options for s3_datastore

        def s3_datastore?
          config.s3_datastore.presence || Refinery::Dragonfly.s3_datastore
        end

        def s3_access_key_id
          config.s3_access_key_id.presence || Refinery::Dragonfly.s3_access_key_id
        end

        def s3_bucket_name
          config.s3_bucket_name.presence || Refinery::Dragonfly.s3_bucket_name
        end

        def s3_fog_storage_options
          config.s3_fog_storage_options.presence || Refinery::Dragonfly.s3_fog_storage_options
        end

        def s3_host
          config.s3_host.presence || Refinery::Dragonfly.s3_host
        end

        def s3_region
          config.s3_region.presence || Refinery::Dragonfly.s3_region
        end

        def s3_root_path
          config.s3_root_path.presence || Refinery::Dragonfly.s3_root_path
        end

        def s3_scheme
          config.s3_scheme.presence || Refinery::Dragonfly.s3_scheme
        end

        def s3_secret_access_key
          config.s3_secret_access_key.presence || Refinery::Dragonfly.s3_secret_access_key
        end

        def s3_storage_headers
          config.s3_storage_headers.presence || Refinery::Dragonfly.s3_storage_headers
        end

        def s3_use_iam_profile
          config.s3_use_iam_profile.presence || Refinery::Dragonfly.s3_use_iam_profile
        end
      end
  end
end
