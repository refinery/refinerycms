module Refinery
  module Resources

    extend Refinery::Dragonfly::ExtensionConfiguration
    include ActiveSupport::Configurable

    config_accessor :max_file_size, :pages_per_dialog, :pages_per_admin_index, :content_disposition

    self.content_disposition = :attachment
    self.max_file_size = 52_428_800
    self.pages_per_dialog = 12
    self.pages_per_admin_index = 20

    self.dragonfly_name = :refinery_resources

  end
end

