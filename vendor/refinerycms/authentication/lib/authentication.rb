require 'refinery'

module Refinery
  module Authentication

    class Engine < Rails::Engine
      config.autoload_paths += %W( #{config.root}/lib )

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_users"
          plugin.version = %q{0.9.8}
          plugin.menu_match = /(refinery|admin)\/users$/
          plugin.activity = {
            :class => User,
            :title => 'login'
          }
          plugin.url = {:controller => "/admin/users"}
        end
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
