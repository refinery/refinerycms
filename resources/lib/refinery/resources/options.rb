module Refinery
  module Resources
    class Options
      include Rails::Railtie::Configurable
      
      DEFAULT_MAX_FILE_SIZE = 52428800
      DEFAULT_PAGES_PER_DIALOG = 12
      
      cattr_accessor :max_file_size
      self.max_file_size = DEFAULT_MAX_FILE_SIZE
      
      cattr_accessor :pages_per_dialog
      self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
      
      class << self
        def reset!
          self.max_file_size = DEFAULT_MAX_FILE_SIZE
          self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
        end
      end
    end
  end
end