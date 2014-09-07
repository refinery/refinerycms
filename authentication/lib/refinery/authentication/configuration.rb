module Refinery
  module Authentication
    include ActiveSupport::Configurable

    config_accessor :superuser_can_assign_roles, :email_from_name

    self.superuser_can_assign_roles = false
    self.email_from_name = "no-reply"

    class << self
      def email_from_name
        ::I18n.t('email_from_name', :scope => 'refinery.authentication.config', :default => config.email_from_name)
      end
    end
  end
end
