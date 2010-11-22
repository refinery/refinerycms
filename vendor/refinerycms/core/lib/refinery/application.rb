module Refinery
  module Application
    def self.included(base)
      self.instance_eval %(
        def self.method_missing(method_sym, *arguments, &block)
          #{base}.send(method_sym)
        end
      )

      # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
      base.config.i18n.load_path += Dir[Refinery.root.join('vendor', 'refinerycms', '*/config/locales/*.{rb,yml}').to_s]
      # config.i18n.default_locale = :de

      # JavaScript files you want as :defaults (application.js is always included).
      base.config.action_view.javascript_expansions[:defaults] = %w()

      # Configure the default encoding used in templates for Ruby 1.9.
      base.config.encoding = "utf-8"

      # Configure sensitive parameters which will be filtered from the log file.
      base.config.filter_parameters += [:password, :password_confirmation]

      # Specify a cache store to use
      base.config.cache_store = :memory_store

      # Extend the application controller
      base.config.to_prepare do
        ::ApplicationController.instance_eval do
          include ::Refinery::ApplicationController
        end if defined?(::ApplicationController)

        ::ApplicationHelper.instance_eval do
          include ::Refinery::ApplicationHelper
        end if defined?(::ApplicationHelper)
      end

      # load in any settings that the developer wants after the initialization.
      base.config.after_initialize do
        require Rails.root.join('config', 'settings.rb')
      end if Rails.root.join('config', 'settings.rb').exist?
    end
  end
end