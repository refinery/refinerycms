module Refinery
  module Resources
    include ActiveSupport::Configurable

    config_accessor :dragonfly_insert_before, :max_file_size, :pages_per_dialog,
                    :pages_per_admin_index

    self.dragonfly_insert_before = 'ActionDispatch::Callbacks'
    self.max_file_size = 52428800
    self.pages_per_dialog = 12
    self.pages_per_admin_index = 20
  end
end