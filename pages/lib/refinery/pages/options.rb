module Refinery
  module Pages
    class Options
      include Rails::Railtie::Configurable
  
      DEFAULT_PAGES_PER_DIALOG = 14
      DEFAULT_PAGES_PER_ADMIN_INDEX = 20
  
      cattr_accessor :pages_per_dialog
      self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
  
      cattr_accessor :pages_per_admin_index
      self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX
  
      class << self
        def reset!
          self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
          self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX
        end
      end
    end
  end
end
