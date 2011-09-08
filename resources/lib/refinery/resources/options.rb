module Refinery
  module Resources
    class Options
      include Rails::Railtie::Configurable
      
      DEFAULT_MAX_FILE_SIZE = 52428800
      DEFAULT_PAGES_PER_DIALOG = 12
      DEFAULT_PAGES_PER_ADMIN_INDEX = 20
      
      cattr_accessor :max_file_size
      self.max_file_size = DEFAULT_MAX_FILE_SIZE
      
      cattr_accessor :pages_per_dialog
      self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
      
      cattr_accessor :pages_per_admin_index
      self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX
      
      class << self
        def reset!
          self.max_file_size = DEFAULT_MAX_FILE_SIZE
          self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
          self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX
        end
      end
    end
  end
end