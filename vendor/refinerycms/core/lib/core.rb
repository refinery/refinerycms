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
  autoload :Plugin,  File.expand_path('../refinery/plugin', __FILE__)
  autoload :Plugins, File.expand_path('../refinery/plugins', __FILE__)
  autoload :Activity, File.expand_path('../refinery/activity', __FILE__)

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
        app.config.autoload_paths += [
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
  
  module Generators
    # The core engine installer streamlines the installation of custom generated
    # engines. It takes the migrations and seeds in your engine and moves them
    # into the rails app db directory, ready to migrate.
    class EngineInstaller < Rails::Generators::Base
      include Rails::Generators::Migration

      def self.engine_name(name = nil)
        @engine_name = name unless name.nil?
        @engine_name
      end
      
      # Implement the required interface for Rails::Generators::Migration.
      # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
      # can be removed once this issue is fixed:
      # # https://rails.lighthouseapp.com/projects/8994/tickets/3820-make-railsgeneratorsmigrationnext_migration_number-method-a-class-method-so-it-possible-to-use-it-in-custom-generators
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
      
      def generate
        Dir.glob(File.expand_path(File.join(self.class.source_root, '../db/**/**'))).each do |path|
          unless File.directory?(path)
            if path =~ /.*migrate.*/
              migration_template path, Rails.root.join("db/migrate/create_#{self.class.engine_name}")
            else
              template path, Rails.root.join("db/seeds/#{self.class.engine_name}.rb")
            end
          end
        end
        
        puts "------------------------"
        puts "Now run:"
        puts "rake db:migrate"
        puts "------------------------"
      end
    end
  end

end




# Below is a hack until this issue:
# https://rails.lighthouseapp.com/projects/8994/tickets/3820-make-railsgeneratorsmigrationnext_migration_number-method-a-class-method-so-it-possible-to-use-it-in-custom-generators
# is fixed on the Rails project.

require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_model'
require 'active_record'

module ActiveRecord
  module Generators
    class Base < Rails::Generators::NamedBase #:nodoc:
      include Rails::Generators::Migration

      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end
    end
  end
end