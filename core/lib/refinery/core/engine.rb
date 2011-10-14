require 'refinerycms-core'
require 'rails'

module Refinery
  module Core
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace ::Refinery
      engine_name "refinery_core"

      def self.load_decorators
        Dir.glob(File.join(Rails.root, "app/decorators/**/*_decorator.rb")) do |c|
          Rails.application.config.cache_classes ? require(c) : load(c)
        end
      end

      config.autoload_paths += %W( #{config.root}/lib )

      # Attach ourselves to the Rails application.
      config.before_configuration do
        ::Refinery::Core.attach_to_application!
      end

      refinery.after_inclusion &method(:load_decorators).to_proc

      # Wrap errors in spans and cache vendored assets.
      config.to_prepare do
        # This wraps errors in span not div
        ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
          "<span class=\"fieldWithErrors\">#{html_tag}</span>".html_safe
        end
      end

      # set per_page globally
      config.to_prepare do
        WillPaginate.per_page = 20
      end

      # Register the plugin
      config.after_initialize do
        Rails::Engine.send :include, Refinery::Engine

        Refinery.register_engine(Refinery::Core)

        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_core'
          plugin.class_name = 'RefineryEngine'
          plugin.version = ::Refinery.version
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /refinery\/(refinery_core)$/
        end

        # Register the dialogs plugin
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_dialogs'
          plugin.version = ::Refinery.version
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /refinery\/(refinery_)?dialogs/
        end
      end

      initializer 'add catch all routes' do |app|
        app.routes_reloader.paths << File.expand_path('../../catch_all_routes.rb', __FILE__)
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

      initializer "refinery.assets.precompile" do |app|
         app.config.assets.precompile += [
           "refinery/*",
           "refinery/icons/*",
           "wymeditor/lang/*",
           "wymeditor/skins/refinery/*",
           "wymeditor/skins/refinery/**/*",
           "modernizr-min.js",
           "dd_belatedpng.js"
        ]
      end
    end
  end
end
