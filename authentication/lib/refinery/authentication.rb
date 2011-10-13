require 'refinerycms-core'

module Refinery
  class << self
    attr_accessor :authentication_login_field
    def authentication_login_field
      @authentication_login_field ||= 'login'
    end
  end

  module Authentication
    require 'refinery/authentication/engine' if defined?(Rails)
    require 'refinery/generators/authentication_generator'

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
