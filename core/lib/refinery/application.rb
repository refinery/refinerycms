module Refinery
  module Application
    class << self
      def refine!
        ::ApplicationHelper.send :include, ::Refinery::ApplicationHelper

        [::ApplicationController, ::Admin::BaseController].each do |c|
          c.send :include, ::Refinery::ApplicationController
          c.send :helper, :application
        end

        ::Admin::BaseController.send :include, ::Refinery::Admin::BaseController
      end

      def included(base)
        self.instance_eval %(
          def self.method_missing(method_sym, *arguments, &block)
            #{base}.send(method_sym)
          end
        )

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
          ::Refinery::Application.refine!
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
