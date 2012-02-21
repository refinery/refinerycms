module Refinery
  module Authentication
    include ActiveSupport::Configurable

    config_accessor :superuser_can_assign_roles

    self.superuser_can_assign_roles = false
  end
end
