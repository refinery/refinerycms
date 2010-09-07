require 'rails/all'
require 'awesome_nested_set'
require 'acts_as_indexed'
require 'friendly_id'
require 'truncate_html'
require 'will_paginate'

module Refinery
  autoload :Plugin,  'refinery/plugin'
  autoload :Plugins, 'refinery/plugins'
  autoload :Activity, 'refinery/activity'

  module Core
    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.autoload_paths += %W( #{config.root}/lib )

      initializer 'add catch all routes' do |app|
        app.routes_reloader.paths << File.expand_path('../refinery/catch_all_routes.rb', __FILE__)
      end

      initializer 'add presenters' do |app|
        app.config.load_paths += [
          Rails.root.join("app", "presenters"),
          Rails.root.join("vendor", "**", "**", "app", "presenters"),
          Refinery.root.join("vendor", "refinerycms", "*", "app", "presenters")
        ].flatten
      end

      config.to_prepare do
        Rails.cache.clear

        # TODO: Is there a better way to cache assets in engines?
        ::ActionView::Helpers::AssetTagHelper.module_eval do
          def asset_file_path(path)
            unless File.exist?(return_path = File.join(config.assets_dir, path.split('?').first))
              ::Refinery::Plugins.registered.collect{|p| p.pathname}.compact.each do |pathname|
                if File.exist?(plugin_asset_path = File.join(pathname.to_s, 'public', path.split('?').first))
                  return_path = plugin_asset_path.to_s
                end
              end
            end

            return_path
          end
        end
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name ="refinery_core"
          plugin.class_name ="RefineryEngine"
          plugin.version = %q{0.9.8}
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /(refinery|admin)\/(refinery_core|base)$/
        end

        # Register the dialogs plugin
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_dialogs"
          plugin.version = %q{0.9.8}
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /(refinery|admin)\/(refinery_)?dialogs/
        end
      end
    end
  end
end
