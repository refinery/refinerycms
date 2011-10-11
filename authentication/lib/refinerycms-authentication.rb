require 'devise'
require 'refinerycms-core'
require 'friendly_id'
require File.expand_path('../generators/authentication_generator', __FILE__)

module Refinery
  module Authentication
    class << self
      def factory_paths
        @factory_paths ||= [ File.expand_path("../../spec/factories", __FILE__) ]
      end
    end
    
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery

      config.autoload_paths += %W( #{config.root}/lib )

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_users'
          plugin.version = %q{2.0.0}
          plugin.menu_match = /refinery\/users$/
          plugin.activity = {
            :class => User,
            :title => 'username'
          }
          plugin.url = app.routes.url_helpers.refinery_admin_users_path
        end
      end

      refinery.before_inclusion do
        [::Refinery::ApplicationController, ::Refinery::ApplicationHelper].each do |c|
          c.send :require, File.expand_path('../authenticated_system', __FILE__)
          c.send :include, ::Refinery::AuthenticatedSystem
        end
      end
    end

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end
  end

  class << self
    attr_accessor :authentication_login_field
    def authentication_login_field
      @authentication_login_field ||= 'login'
    end
  end
end

::Refinery.engines << 'authentication'
