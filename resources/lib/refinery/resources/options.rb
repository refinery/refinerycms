module Refinery
  module Resources
    class Options
      include Rails::Railtie::Configurable
      
      DEFAULT_MAX_FILE_SIZE = 52428800
      
      cattr_accessor :max_file_size
      self.max_file_size = DEFAULT_MAX_FILE_SIZE
      
      class << self
        def reset!
          self.max_file_size = DEFAULT_MAX_FILE_SIZE
        end
      end
    end
  end
end