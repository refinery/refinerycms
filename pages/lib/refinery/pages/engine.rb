require 'refinerycms-pages'
require 'rails'

module Refinery
  module Pages
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_pages

      config.autoload_paths += %W( #{config.root}/lib )

      config.to_prepare do |app|
        Refinery::Page.translation_class.send(:is_seo_meta) unless ENV['RAILS_ASSETS_PRECOMPILE']
        Refinery::Page.translation_class.send(:attr_accessible, :browser_title, :meta_description, :meta_keywords, :locale)
      end

      after_inclusion do
        ::ApplicationController.send :include, Refinery::Pages::InstanceMethods
        Refinery::AdminController.send :include, Refinery::Pages::Admin::InstanceMethods
      end

      initializer "append marketable routes", :before => :set_routes_reloader do |app|
        if Refinery::Pages.marketable_urls
          append_marketable_routes(app)
        end
      end

      initializer "register refinery_pages plugin", :after => :set_routes_reloader do |app|
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_pages'
          plugin.directory = 'pages'
          plugin.version = %q{2.0.0}
          plugin.menu_match = /refinery\/page(_part)?s(_dialogs)?$/
          plugin.url = app.routes.url_helpers.refinery_admin_pages_path
          plugin.activity = {
            :class_name => :'refinery/page',
            :url_prefix => "edit",
            :title => "title",
            :created_image => "page_add.png",
            :updated_image => "page_edit.png",
            :url => "refinery_admin_page_path" # temp hack for namespacees
          }
        end
      end

      initializer "add marketable route parts to reserved words" do |app|
        if Refinery::Pages.marketable_urls
          # ENV['RAILS_ASSETS_PRECOMPILE'] is a temporary hack to avoid initializing the database during
          # assets precompile for issue https://github.com/resolve/refinerycms/issues/1059
          add_route_parts_as_reserved_words(app) unless ENV['RAILS_ASSETS_PRECOMPILE']
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Pages)
      end

      protected

        def append_marketable_routes(app)
          app.routes.append do
            scope(:module => 'refinery') do
              get '*path', :to => 'pages#show'
            end
          end
        end

        # Add any parts of routes as reserved words.
        def add_route_parts_as_reserved_words(app)
          route_paths = app.routes.named_routes.routes.map { |name, route| route.path }
          Refinery::Page.friendly_id_config.reserved_words |= route_paths.map { |path|
            path.to_s.gsub(/^\//, '').to_s.split('(').first.to_s.split(':').first.to_s.split('/')
          }.flatten.reject { |w| w =~ /\_/ }.uniq
        end
    end
  end
end
