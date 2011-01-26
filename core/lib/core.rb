require 'rails/all'

require 'acts_as_indexed'
require 'awesome_nested_set'
require 'dragonfly'
require 'devise'
require 'friendly_id'
require 'truncate_html'
require 'will_paginate'
require 'rails/generators'
require 'rails/generators/migration'

module Refinery

  autoload :Activity, File.expand_path('../refinery/activity', __FILE__)
  autoload :Application, File.expand_path('../refinery/application', __FILE__)
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

      # Register the plugin
      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name ="refinery_core"
          plugin.class_name ="RefineryEngine"
          plugin.version = Refinery.version.to_s
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /(refinery|admin)\/(refinery_core)$/
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

      # Run other initializer code that used to be in config/initializers/
      initializer "serve static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      initializer 'add catch all routes' do |app|
        app.routes_reloader.paths << File.expand_path('../refinery/catch_all_routes.rb', __FILE__)
      end

      initializer 'add presenters' do |app|
        app.config.autoload_paths += [
          Rails.root.join("app", "presenters"),
          Rails.root.join("vendor", "**", "**", "app", "presenters"),
          Refinery.root.join("**", "app", "presenters")
        ].flatten
      end

      initializer "configure acts_as_indexed" do |app|
        ActsAsIndexed.configure do |config|
          config.index_file = Rails.root.join('tmp', 'index')
          config.index_file_depth = 3
          config.min_word_size = 3
        end
      end

      initializer "fix rack <= 1.2.1" do |app|
        ::Rack::Utils.module_eval do
          def escape(s)
            regexp = case
              when RUBY_VERSION >= "1.9" && s.encoding === Encoding.find('UTF-8')
                /([^ a-zA-Z0-9_.-]+)/u
              else
                /([^ a-zA-Z0-9_.-]+)/n
              end
            s.to_s.gsub(regexp) {
              '%'+$1.unpack('H2'*bytesize($1)).join('%').upcase
            }.tr(' ', '+')
          end
        end if ::Rack.version <= "1.2.1"
      end

      initializer 'set will_paginate link labels' do |app|
        WillPaginate::ViewHelpers.pagination_options[:previous_label] = "&laquo;".html_safe
        WillPaginate::ViewHelpers.pagination_options[:next_label] = "&raquo;".html_safe
      end

      initializer 'ensure devise is initialised' do |app|
        unless Rails.root.join('config', 'initializers', 'devise.rb').file?
          load Refinery.root.join(*%w(core lib generators templates config initializers devise.rb))
        end
      end

    end
  end

end
