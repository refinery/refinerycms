module Refinery
  module Images

    extend Refinery::Dragonfly::ExtensionConfiguration
    include ActiveSupport::Configurable

    config_accessor :max_image_size, :pages_per_dialog, :pages_per_admin_index,
                    :pages_per_dialog_that_have_size_options, :user_image_sizes, :user_image_ratios,
                    :image_views, :preferred_image_view,
                    :whitelisted_mime_types

    self.max_image_size = 5_242_880
    self.pages_per_dialog = 18
    self.pages_per_dialog_that_have_size_options = 12
    self.pages_per_admin_index = 20
    self.user_image_sizes = {
      small: '110x110>',
      medium: '225x255>',
      large: '450x450>'
    }
    self.user_image_ratios = {
      '16/9': '1.778',
      '4/3': '1.333',
      '1:1': 1
    }
    self.whitelisted_mime_types = %w[image/jpeg image/png image/gif image/tiff]
    self.image_views = [:grid, :list]
    self.preferred_image_view = :grid

    # Images should always use these changes to the dragonfly defaults
    self.dragonfly_name         = :refinery_images
    self.dragonfly_plugin       = :imagemagick

    # Dragonfly processor to strip image of all profiles and comments (imagemagick conversion -strip)
    self.dragonfly_processors   = [{
      name: :strip,
      block: -> (content) { content.process!(:convert, '-strip') }
    }]

  end
end
