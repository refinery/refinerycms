require 'rails/all'
require 'acts_as_indexed'
require 'friendly_id'
require 'truncate_html'
require 'will_paginate'

module Refinery

  autoload :Plugin,  'refinery/plugin'
  autoload :Plugins, 'refinery/plugins'
  autoload :Activity, 'refinery/activity'

  class Engine < Rails::Engine
    initializer "static assets" do |app|
      app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
    end

    config.autoload_paths += %W( #{config.root}/lib )

    initializer 'add catch all routes' do |app|
      app.routes_reloader.paths << File.expand_path('../refinery/catch_all_routes.rb', __FILE__)
    end

    config.to_prepare do
      require_dependency 'refinery/form_helpers'
      require_dependency 'refinery/base_presenter'

      [
        Refinery.root.join("vendor", "plugins", "*", "app", "presenters"),
        Rails.root.join("app", "presenters")
      ].each do |path|
        Dir[path.to_s].each do |presenters_path|
          $LOAD_PATH << presenters_path
          ::ActiveSupport::Dependencies.load_paths << presenters_path
        end
      end
    end

    config.after_initialize do
      Refinery::Plugin.register do |plugin|
        plugin.title = "Refinery"
        plugin.name = "refinery_core"
        plugin.description = "Core refinery plugin"
        plugin.version = %q{0.9.8}
        plugin.hide_from_menu = true
        plugin.always_allow_access = true
        plugin.menu_match = /(refinery|admin)\/(refinery_core|base)$/
      end

      # Register the dialogs plugin
      Refinery::Plugin.register do |plugin|
        plugin.title = "Dialogs"
        plugin.name = "refinery_dialogs"
        plugin.description = "Refinery Dialogs plugin"
        plugin.version = %q{0.9.8}
        plugin.hide_from_menu = true
        plugin.always_allow_access = true
        plugin.menu_match = /(refinery|admin)\/(refinery_)?dialogs/
      end
    end
  end
end
