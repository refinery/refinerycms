# require application helper so that we can include our helpers into it.
if defined?(Rails) and !Rails.root.nil? and (app_helper = Rails.root.join('app', 'helpers', 'application_helper.rb')).file?
  require app_helper.to_s
end

module Refinery
  module Application
    class << self
      def included(base)
        self.instance_eval %(
          def self.method_missing(method_sym, *arguments, &block)
            #{base}.send(method_sym)
          end
        )

        # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
        base.config.i18n.load_path += Dir[Refinery.root.join('*/config/locales/*.{rb,yml}').to_s]
        # config.i18n.default_locale = :de

        # JavaScript files you want as :defaults (application.js is always included).
        base.config.action_view.javascript_expansions[:defaults] = %w()

        # Configure the default encoding used in templates for Ruby 1.9.
        base.config.encoding = "utf-8"

        # Configure sensitive parameters which will be filtered from the log file.
        base.config.filter_parameters += [:password, :password_confirmation]

        # Specify a cache store to use
        base.config.cache_store = :memory_store

        # Include the refinery controllers and helpers dynamically
        base.config.to_prepare do
          ::ApplicationHelper.send :include, ::Refinery::ApplicationHelper

          [::ApplicationController, ::Admin::BaseController].each do |c|
            c.send :include, ::Refinery::ApplicationController
            c.send :helper, :application
          end

          ::Admin::BaseController.send :include, ::Refinery::AdminBaseController
        end

        # load in any settings that the developer wants after the initialization.
        base.config.after_initialize do
          if (settings = Rails.root.join('config', 'settings.rb')).exist?
            require settings.to_s
          end
        end
      end
    end
  end
end
