require 'rails/all'

require 'acts_as_indexed'
require 'authlogic'
require 'awesome_nested_set'
require 'dragonfly'
require 'friendly_id'
require 'truncate_html'
require 'will_paginate'
require 'rails/generators'
require 'rails/generators/migration'

module Refinery

  autoload :Activity, File.expand_path('../refinery/activity', __FILE__)
  autoload :Application, File.expand_path('../refinery/application', __FILE__)
  autoload :Generators, File.expand_path('../refinery/generators', __FILE__)
  autoload :Plugin,  File.expand_path('../refinery/plugin', __FILE__)
  autoload :Plugins, File.expand_path('../refinery/plugins', __FILE__)

  module Core
    class << self
      def attach_to_application!
        ::Rails::Application.subclasses.each do |subclass|
          begin
            subclass.send :include, ::Refinery::Application
          rescue
            $stdout.puts "Refinery CMS couldn't attach to #{subclass.name}."
            $stdout.puts "Error was: #{$!.message}"
            $stdout.puts $!.backtrace
          end
        end
      end
    end

    class Engine < Rails::Engine

      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.autoload_paths += %W( #{config.root}/lib )

      initializer 'add catch all routes' do |app|
        app.routes_reloader.paths << File.expand_path('../refinery/catch_all_routes.rb', __FILE__)
      end

      initializer 'add presenters' do |app|
        app.config.autoload_paths += [
          Rails.root.join("app", "presenters"),
          Rails.root.join("vendor", "**", "**", "app", "presenters"),
          Refinery.root.join("vendor", "refinerycms", "*", "app", "presenters")
        ].flatten
      end

      # Attach ourselves to the Rails application.
      config.before_initialize do
        ::Refinery::Core.attach_to_application!
      end

      config.to_prepare do
        ::Rails.cache.clear

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
          plugin.version = Refinery.version.to_s
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /(refinery|admin)\/(refinery_core|base)$/
        end

        # Register the dialogs plugin
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_dialogs"
          plugin.version = Refinery.version.to_s
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /(refinery|admin)\/(refinery_)?dialogs/
        end
      end
    end
  end

end
