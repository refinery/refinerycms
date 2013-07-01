module Refinery
  module Authentication
    class Engine < ::Rails::Engine
      extend Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_authentication

      config.autoload_paths += %W( #{config.root}/lib )

      initializer "register refinery_user plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_users'
          plugin.menu_match = %r{refinery/users$}
          plugin.activity = {
            :class_name => :'refinery/user',
            :title => 'username'
          }
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_users_path }
        end
      end

      before_inclusion do
        [Refinery::AdminController, ::ApplicationController].each do |c|
          Refinery.include_once(c, Refinery::AuthenticatedSystem)
        end
      end

      config.before_configuration do
        require 'refinery/authentication/devise'
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Authentication)
      end
    end
  end
end
