module Refinery
  module Images
    class Options
      include Rails::Railtie::Configurable
  
      DEFAULT_MAX_IMAGE_SIZE = 5242880
      DEFAULT_PAGES_PER_DIALOG = 18
      DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS = 12
      DEFAULT_PAGES_PER_ADMIN_INDEX = 20
  
      cattr_accessor :max_image_size
      self.max_image_size = DEFAULT_MAX_IMAGE_SIZE
  
      cattr_accessor :pages_per_dialog
      self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
  
      cattr_accessor :pages_per_dialog_that_have_size_options
      self.pages_per_dialog_that_have_size_options = DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
  
      cattr_accessor :pages_per_admin_index
      self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX
  
      class << self
        def reset!
          self.max_image_size = DEFAULT_MAX_IMAGE_SIZE
          self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
          self.pages_per_dialog_that_have_size_options = DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
          self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX
        end
      end
    end
  end
end
