module Refinery
  module Core
    include ActiveSupport::Configurable

    config_accessor :rescue_not_found, :s3_backend, :base_cache_key, :site_name,
                    :google_analytics_page_code, :authenticity_token_on_frontend,
                    :menu_hide_children, :dragonfly_secret, :ie6_upgrade_message_enabled,
                    :show_internet_explorer_upgrade_message

    self.rescue_not_found = false
    self.s3_backend = false
    self.base_cache_key = :refinery
    self.site_name = "Company Name"
    self.google_analytics_page_code = "UA-xxxxxx-x"
    self.authenticity_token_on_frontend = true
    self.menu_hide_children = false
    self.dragonfly_secret = Array.new(24) { rand(256) }.pack('C*').unpack('H*').first
    self.ie6_upgrade_message_enabled = true
    self.show_internet_explorer_upgrade_message = false
  end
end
