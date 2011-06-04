require 'devise'
require 'refinerycms-core'
require 'friendly_id'

module Refinery
  module Authentication

    class Engine < ::Rails::Engine

      initializer 'serve static assets' do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.autoload_paths += %W( #{config.root}/lib )

      config.after_initialize do
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_users'
          plugin.version = %q{1.0.0}
          plugin.menu_match = /(refinery|admin)\/users$/
          plugin.activity = {
            :class => User,
            :title => 'username'
          }
          plugin.url = {:controller => '/admin/users'}
        end
      end

      refinery.before_inclusion do
        [::Refinery::ApplicationController, ::Refinery::ApplicationHelper].each do |c|
          c.send :require, File.expand_path('../authenticated_system', __FILE__)
          c.send :include, AuthenticatedSystem
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
