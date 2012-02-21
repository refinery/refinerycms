module Refinery
  module Dashboard
    include ActiveSupport::Configurable

    config_accessor :activity_show_limit

    self.activity_show_limit = 7
  end
end
