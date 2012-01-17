module Refinery
  module Images
    include ActiveSupport::Configurable

    config_accessor :dragonfly_insert_before, :dragonfly_secret, :dragonfly_url_format,
                    :max_image_size, :pages_per_dialog, :pages_per_admin_index,
                    :pages_per_dialog_that_have_size_options, :user_image_sizes,
                    :image_views, :preferred_image_view, :datastore_root_path,
                    :s3_backend, :s3_bucket_name, :s3_region,
                    :s3_access_key_id, :s3_secret_access_key

    self.dragonfly_insert_before = 'ActionDispatch::Callbacks'
    self.dragonfly_secret = Refinery::Core.dragonfly_secret
    self.dragonfly_url_format = '/system/images/:job/:basename.:format'

    self.max_image_size = 5242880
    self.pages_per_dialog = 18
    self.pages_per_dialog_that_have_size_options = 12
    self.pages_per_admin_index = 20
    self.user_image_sizes = { :small => '110x110>',
                              :medium => '225x255>',
                              :large => '450x450>' }
    self.image_views = [:grid, :list]
    self.preferred_image_view = :grid

    self.s3_bucket_name = ENV['S3_BUCKET']
    self.s3_access_key_id = ENV['S3_KEY']
    self.s3_secret_access_key = ENV['S3_SECRET']

    # We have to configure these settings after Rails is available.
    # But a non-nil custom option can still be provided
    class << self
      def datastore_root_path
        config.datastore_root_path ||= Rails.root.join('public', 'system', 'refinery', 'images').to_s
      end

      def s3_backend
        config.s3_backend.nil? ? Refinery::Core.s3_backend : config.s3_backend
      end
    end
  end
end
