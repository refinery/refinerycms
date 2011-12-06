require 'refinerycms-core'

module Refinery
  autoload :AuthenticatedSystem, 'refinery/authenticated_system'

  class << self
    attr_accessor :authentication_login_field
    def authentication_login_field
      @authentication_login_field ||= 'login'
    end
  end

  module Authentication
    require 'refinery/authentication/engine' if defined?(Rails)

    include ActiveSupport::Configurable

    config_accessor :superuser_can_assign_roles

    self.superuser_can_assign_roles = false

    class << self
      def factory_paths
        @factory_paths ||= [ root.join("spec/factories").to_s ]
      end

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
