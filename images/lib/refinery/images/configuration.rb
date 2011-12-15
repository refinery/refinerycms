module Refinery
  module Images
    include ActiveSupport::Configurable

    config_accessor :dragonfly_insert_before, :max_image_size, :pages_per_dialog,
                    :pages_per_admin_index, :pages_per_dialog_that_have_size_options,
                    :user_image_sizes

    self.dragonfly_insert_before = 'ActionDispatch::Callbacks'
    self.max_image_size = 5242880
    self.pages_per_dialog = 18
    self.pages_per_dialog_that_have_size_options = 12
    self.pages_per_admin_index = 20
    self.user_image_sizes = { :small => '110x110>',
                              :medium => '225x255>',
                              :large => '450x450>' }
  end
end
