module Refinery
  module Dragonfly

    include ActiveSupport::Configurable

    # All dragonfly options allowed
    config_accessor :allow_legacy_urls, :analysers,
                    :before_serve,
                    :cache_log_level, :cache_store_root,
                    :custom_datastore_class, :custom_datastore_opts,
                    :datastore_root_path, :define_url, :dragonfly_url,
                    :fetch_file_whitelist, :fetch_url_whitelist,
                    :generators,
                    :mime_types,
                    :name,
                    :path_prefix, :plugin, :processors,
                    :response_header,
                    :secret,
                    :url_format, :url_host, :url_path_prefix,
                    :verify_urls,

                    #  s3 options

                    :s3_access_key_id,
                    :s3_datastore, :s3_bucket_name,

                    :s3_fog_storage_options,
                    :s3_region, :s3_root_path,
                    :s3_secret_access_key, :s3_storage_path, :s3_storage_headers,
                    :s3_url_host, :s3_url_scheme, :s3_use_iam_profile


    self.allow_legacy_urls = false
    self.analysers = []
    self.before_serve = nil

    self.cache_log_level = 'verbose'
    self.cache_store_root = 'tmp/dragonfly'
    self.custom_datastore_class = nil
    self.custom_datastore_opts = {}

    self.datastore_root_path = 'public/system/refinery/dragonfly'
    self.define_url = nil
    self.dragonfly_url = nil
    self.fetch_file_whitelist = nil
    self.fetch_url_whitelist = nil
    self.generators = []
    self.mime_types = []
    self.name = 'dragonfly'
    self.path_prefix = nil
    self.plugin = ''
    self.processors = []
    self.response_header = nil
    self.secret = Array.new(24) { rand(256) }.pack('C*').unpack('H*').first
    self.url_path_prefix = ''
    self.url_host = ''
    self.verify_urls = true

    # s3 Data Store Config
    # When using s3 as data store, make sure to add the dragonfly-s3_data_store gem to your project
    self.s3_datastore = false
    self.s3_bucket_name = ENV['S3_BUCKET']
    self.s3_access_key_id = ENV['S3_KEY']
    self.s3_secret_access_key = ENV['S3_SECRET']
    self.s3_region = ENV['S3_REGION']           # default 'us-east-1' see Dragonfly S3DataStore :s3_REGIONS for options
    self.s3_url_scheme = nil                    # defaults to "http"
    self.s3_url_host = nil                      # defaults to "<bucket-name>.s3.amazonaws.com" or "s3.amazonaws.com/<bucket-name>" if not a valid subdomain
    self.s3_use_iam_profile = nil               # boolean - if true no need for access_key_id or secret_access_key
    self.s3_root_path = nil                     # store all content under a subdirectory - uids will be relative to this - defaults to nil
    self.s3_fog_storage_options = nil           # hash for passing any extra options to Fog

    # Per-storage options
    self.s3_storage_path = nil
    self.s3_storage_headers = nil


    def self.custom_datastore?
      config.custom_datastore_class.present? && config.custom_datastore_opts.present?
    end

    def self.url_format(url_segment='dragonfly')
      "/system/refinery/#{url_segment}/:job/:basename.:ext"
    end
  end

end
