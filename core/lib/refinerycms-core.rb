require 'acts_as_indexed'
require 'truncate_html'
require 'will_paginate'

module Refinery
  autoload :Activity, File.expand_path('../refinery/activity', __FILE__)
  autoload :Application, File.expand_path('../refinery/application', __FILE__)
  autoload :ApplicationController, File.expand_path('../refinery/application_controller', __FILE__)
  autoload :ApplicationHelper, File.expand_path('../refinery/application_helper', __FILE__)
  autoload :Configuration, File.expand_path('../refinery/configuration', __FILE__)
  autoload :Engine, File.expand_path('../refinery/engine', __FILE__)
  autoload :Menu, File.expand_path('../refinery/menu', __FILE__)
  autoload :MenuItem, File.expand_path('../refinery/menu_item', __FILE__)
  autoload :Plugin,  File.expand_path('../refinery/plugin', __FILE__)
  autoload :Plugins, File.expand_path('../refinery/plugins', __FILE__)
end

# These have to be specified after the autoload to correct load issues on some systems.
# As per commit 12af0e3e83a147a87c97bf7b29f343254c5fcb3c
require 'refinerycms-base'
require 'refinerycms-generators'
require 'refinerycms-settings'
require 'rails/generators'
require 'rails/generators/migration'

module Refinery

  class << self
    def config
      @@config ||= ::Refinery::Configuration.new
    end
  end

  module Core
    class << self
      def attach_to_application!
        ::Rails::Application.subclasses.each do |subclass|
          begin
            # Fix Rake 0.9.0 issue
            subclass.send :include, ::Rake::DSL if defined?(::Rake::DSL)

            # Include our logic inside your logic
            subclass.send :include, ::Refinery::Application
          rescue
            $stdout.puts "Refinery CMS couldn't attach to #{subclass.name}."
            $stdout.puts "Error was: #{$!.message}"
            $stdout.puts $!.backtrace
          end
        end
      end

      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    ::Rails::Engine.module_eval do
      include ::Refinery::Engine
    end

    class Engine < ::Rails::Engine

      config.autoload_paths += %W( #{config.root}/lib )

      # Attach ourselves to the Rails application.
      config.before_configuration do
        ::Refinery::Core.attach_to_application!
      end

      # Wrap errors in spans and cache vendored assets.
      config.to_prepare do
        # This wraps errors in span not div
        ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
          "<span class=\"fieldWithErrors\">#{html_tag}</span>".html_safe
        end

        # TODO: Is there a better way to cache assets in engines?
        # Also handles a change in Rails 3.1 with AssetIncludeTag being invented.
        tag_helper_class = if defined?(::ActionView::Helpers::AssetTagHelper::AssetIncludeTag)
          ::ActionView::Helpers::AssetTagHelper::AssetIncludeTag
        else
          ::ActionView::Helpers::AssetTagHelper
        end
        tag_helper_class.module_eval do
          def asset_file_path(path)
            unless (return_path = Pathname.new(File.join(config.assets_dir, path.split('?').first))).exist?
              this_asset_filename = path.split('?').first.to_s.gsub(/^\//, '')
              ::Refinery::Plugins.registered.pathnames.each do |pathname|
                if (pathname_asset_path = pathname.join('public', this_asset_filename)).exist?
                  return_path = pathname_asset_path
                end
              end
            end
            return_path.to_s
          end
        end
      end

      # Register the plugin
      config.after_initialize do
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_core'
          plugin.class_name = 'RefineryEngine'
          plugin.version = ::Refinery.version
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /(refinery|admin)\/(refinery_core)$/
        end

        # Register the dialogs plugin
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_dialogs'
          plugin.version = ::Refinery.version
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /(refinery|admin)\/(refinery_|pages_)?dialogs/
        end
      end

      # Run other initializer code that used to be in config/initializers/
      initializer 'serve static assets' do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      initializer 'add catch all routes' do |app|
        app.routes_reloader.paths << File.expand_path('../refinery/catch_all_routes.rb', __FILE__)
      end

      initializer 'add presenters' do |app|
        app.config.autoload_paths += [
          Rails.root.join('app', 'presenters'),
          Rails.root.join('vendor', '**', '**', 'app', 'presenters'),
          Refinery.roots.map{|r| r.join('**', 'app', 'presenters')}
        ].flatten
      end

      initializer 'configure acts_as_indexed' do |app|
        ActsAsIndexed.configure do |config|
          config.index_file = Rails.root.join('tmp', 'index')
          config.index_file_depth = 3
          config.min_word_size = 3
        end
      end

      initializer 'fix rack <= 1.2.1' do |app|
        ::Rack::Utils.module_eval do
          def escape(s)
            regexp = case
              when RUBY_VERSION >= '1.9' && s.encoding === Encoding.find('UTF-8')
                /([^ a-zA-Z0-9_.-]+)/u
              else
                /([^ a-zA-Z0-9_.-]+)/n
              end
            s.to_s.gsub(regexp) {
              '%'+$1.unpack('H2'*bytesize($1)).join('%').upcase
            }.tr(' ', '+')
          end
        end if ::Rack.version <= '1.2.1'
      end

      initializer 'ensure devise is initialised' do |app|
        unless Rails.root.join('config', 'initializers', 'devise.rb').file?
          load Refinery.roots('core').join(*%w(lib generators templates config initializers devise.rb))
        end
      end

    end
  end

end

::Refinery.engines << 'core'
