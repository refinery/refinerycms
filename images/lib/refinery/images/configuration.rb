module Refinery
  module Images
    include ActiveSupport::Configurable

    config_accessor :dragonfly_insert_before, :dragonfly_secret, :dragonfly_url_format,
                    :max_image_size, :pages_per_dialog, :pages_per_admin_index,
                    :pages_per_dialog_that_have_size_options, :user_image_sizes,
                    :image_views, :preferred_image_view, :datastore_root_path,
                    :s3_backend, :s3_bucket_name, :s3_region,
                    :s3_access_key_id, :s3_secret_access_key, :trust_file_extensions,
                    :whitelisted_mime_types

    self.dragonfly_insert_before = 'ActionDispatch::Callbacks'
    self.dragonfly_secret = Refinery::Core.dragonfly_secret
    # If you decide to trust file extensions replace :ext below with :format
    self.dragonfly_url_format = '/system/images/:job/:basename.:ext'
    self.trust_file_extensions = false

    self.max_image_size = 5242880
    self.pages_per_dialog = 18
    self.pages_per_dialog_that_have_size_options = 12
    self.pages_per_admin_index = 20
    self.user_image_sizes = {
      :small => '110x110>',
      :medium => '225x255>',
      :large => '450x450>'
    }

    self.whitelisted_mime_types = %w[image/jpeg image/png image/gif image/tiff]

    self.image_views = [:grid, :list]
    self.preferred_image_view = :grid

    # We have to configure these settings after Rails is available.
    # But a non-nil custom option can still be provided
    class << self
      def datastore_root_path
        config.datastore_root_path || (Rails.root.join('public', 'system', 'refinery', 'images').to_s if Rails.root)
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
