require 'refinerycms-authentication'
require 'rails'
require 'devise'
require 'friendly_id'

module Refinery
  module Authentication
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :authentication

      config.autoload_paths += %W( #{config.root}/lib )

      initializer "register refinery_user plugin", :after => :set_routes_reloader do |app|
        Refinery::Plugin.register do |plugin|
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

      before_inclusion do
        [Refinery::ApplicationController, Refinery::AdminController, ::ApplicationHelper].each do |c|
          c.send :include, Refinery::AuthenticatedSystem
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Authentication)
      end
    end
  end
end
