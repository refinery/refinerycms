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

    self.s3_backend = Refinery::Core.s3_backend
    self.s3_bucket_name = ENV['S3_BUCKET']
    self.s3_access_key_id = ENV['S3_KEY']
    self.s3_secret_access_key = ENV['S3_SECRET']

    # We have to configure this setting after Rails is available.
    # But a non-nil custom option can still be provided
    class << self
      def datastore_root_path
        config.datastore_root_path ||= Rails.root.join('public', 'system', 'refinery', 'resources').to_s
      end
    end
  end
end
