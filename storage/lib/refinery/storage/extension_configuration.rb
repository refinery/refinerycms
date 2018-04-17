module Refinery
  module Storage
    module ExtensionConfiguration
      include ActiveSupport::Configurable

      config_accessor :storage_allow_legacy_urls, :storage_analysers,
                      :storage_before_serve,
                      :storage_cache_store_root, :storage_cache_log_level,
                      :storage_custom_datastore_class, :storage_custom_datastore_opts,
                      :storage_datastore_root_path, :storage_define_url, :storage_storage_url,
                      :storage_fetch_file_whitelist, :storage_fetch_url_whitelist,
                      :storage_generators,
                      :storage_mime_types,
                      :storage_name,
                      :storage_path_prefix, :storage_plugin, :storage_processors,
                      :storage_response_header,
                      :storage_secret,
                      :storage_url_format, :storage_url_host, :storage_url_path_prefix, :storage_url_segment,
                      :storage_verify_urls,

                      :s3_access_key_id,
                      :s3_datastore, :s3_bucket_name,
                      :s3_fog_storage_options,
                      :s3_region, :s3_root_path,
                      :s3_secret_access_key, :s3_storage_path, :s3_storage_headers,
                      :s3_url_host, :s3_url_scheme, :s3_use_iam_profiles


        def short_name
          config.storage_name.to_s.remove('refinery_')
        end

        def storage_allow_legacy_urls
          config.storage_allow_legacy_urls.presence || Refinery::Storage.allow_legacy_urls
        end

        def storage_analysers
          config.storage_analysers.presence || Refinery::Storage.analysers
        end

        def storage_before_serve
          config.storage_before_serve.presence || Refinery::Storage.before_serve
        end

        def storage_cache_store_root
          config.storage_cache_store.presence || Rails.root.join('tmp', 'storage')
        end

        def storage_cache_log_level
          config.storage_cache_log_level || Refinery::Storage.cache_log_level
        end

        def storage_custom_datastore?
          config.storage_custom_datastore_class.nil? ? Refinery::Storage.custom_datastore? : config.custom_datastore_class.present?
        end

        def storage_custom_datastore_class
          config.storage_custom_datastore_class.nil? ? Refinery::Storage.custom_datastore_class : config.storage_custom_datastore_class.constantize
        end

        def storage_custom_datastore_opts
          config.storage_custom_datastore_opts.presence || Refinery::Storage.custom_datastore_opts
        end

        def storage_datastore_root_path
          config.storage_datastore_root_path.presence || Rails.root.join('public', 'system', 'refinery', short_name).to_s if Rails.root
        end

        def storage_define_url
          config.storage_define_url || Refinery::Storage.define_url
        end

        def storage_storage_url
          config.storage_storage_url || Refinery::Storage.storage_url
        end

        def storage_fetch_file_whitelist
          config.storage_fetch_file_whitelist || Refinery::Storage.fetch_file_whitelist
        end

        def storage_fetch_url_whitelist
          config.storage_fetch_url_whitelist || Refinery::Storage.fetch_url_whitelist
        end

        def storage_generators
          config.storage_generators || Refinery::Storage.generators
        end


        # define one or more new mimetypes
        # storage_mimetypes = [
        #   {ext: 'egg', mimetype: 'fried/egg'},
        #   {ext: 'avo', mimetype: 'smashed/avo'}
        # ]
        #

        def storage_mime_types
          config.storage_mime_types || Refinery::Storage.mime_types
        end

        def storage_name
          config.storage_name || Refinery::Storage.name
        end

        def storage_path_prefix
          config.storage_path_prefix || Refinery::Storage.path_prefix
        end

        def storage_response_header
          config.storage_response_header || Refinery::Storage.response_header
        end

        def storage_secret
          config.storage_secret || Refinery::Storage.secret
        end

        def storage_url
          config.storage_url || Refinery::Storage.url
        end

        def storage_url_format
          config.storage_url_format || Refinery::Storage.url_format(short_name)
        end

        def storage_url_host
          config.storage_url_host || Refinery::Storage.url_host
        end

        def storage_url_path_prefix
          config.storage_url_path_prefix || Refinery::Storage.url_path_prefix
        end

        def storage_url_segment
          config.storage_url_segment || short_name
        end

        def storage_verify_urls
          config.storage_verify_urls.nil? ? Refinery::Storage.verify_urls : config.storage_verify_urls
        end

        # -------------------
        # Options for s3_datastore

        def s3_datastore?
          config.s3_datastore.presence || Refinery::Storage.s3_datastore
        end

        def s3_access_key_id
          config.s3_access_key_id.presence || Refinery::Storage.s3_access_key_id
        end

        def s3_bucket_name
          config.s3_bucket_name.presence || Refinery::Storage.s3_bucket_name
        end

        def s3_fog_storage_options
          config.s3_fog_storage_options.presence || Refinery::Storage.s3_fog_storage_options
        end

        def s3_host
          config.s3_host.presence || Refinery::Storage.s3_host
        end

        def s3_region
          config.s3_region.presence || Refinery::Storage.s3_region
        end

        def s3_root_path
          config.s3_root_path.presence || Refinery::Storage.s3_root_path
        end

        def s3_scheme
          config.s3_scheme.presence || Refinery::Storage.s3_scheme
        end

        def s3_secret_access_key
          config.s3_secret_access_key.presence || Refinery::Storage.s3_secret_access_key
        end

        def s3_storage_headers
          config.s3_storage_headers.presence || Refinery::Storage.s3_storage_headers
        end

        def s3_use_iam_profile
          config.s3_use_iam_profile.presence || Refinery::Storage.s3_use_iam_profile
        end
      end
  end
end
