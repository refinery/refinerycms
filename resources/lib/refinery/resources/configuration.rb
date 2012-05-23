module Refinery
  module Resources
    include ActiveSupport::Configurable

    config_accessor :dragonfly_insert_before, :dragonfly_secret, :dragonfly_url_format,
                    :max_file_size, :pages_per_dialog, :pages_per_admin_index,
                    :s3_backend, :s3_bucket_name, :s3_region,
                    :s3_access_key_id, :s3_secret_access_key,
                    :datastore_root_path

    self.dragonfly_insert_before = 'ActionDispatch::Callbacks'
    self.dragonfly_secret = Refinery::Core.dragonfly_secret
    self.dragonfly_url_format = '/system/resources/:job/:basename.:format'

    self.max_file_size = 52428800
    self.pages_per_dialog = 12
    self.pages_per_admin_index = 20

    # We have to configure these settings after Rails is available.
    # But a non-nil custom option can still be provided
    class << self
      def datastore_root_path
        config.datastore_root_path || (Rails.root.join('public', 'system', 'refinery', 'resources').to_s if Rails.root)
      end

      def s3_backend
        config.s3_backend.nil? ? Refinery::Core.s3_backend : config.s3_backend
      end

      def s3_bucket_name
        config.s3_bucket_name.nil? ? Refinery::Core.s3_bucket_name : config.s3_bucket_name
      end

      def s3_access_key_id
        config.s3_access_key_id.nil? ? Refinery::Core.s3_access_key_id : config.s3_access_key_id
      end

      def s3_secret_access_key
        config.s3_secret_access_key.nil? ? Refinery::Core.s3_secret_access_key : config.s3_secret_access_key
      end
      
      def s3_region
        config.s3_region.nil? ? Refinery::Core.s3_region : config.s3_region
      end
      
    end
  end
end
