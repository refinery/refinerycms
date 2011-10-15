require 'refinerycms-pages'
require 'rails'

module Refinery
  module Pages
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace ::Refinery
      engine_name :refinery_pages

      config.before_initialize do |app|
        # You need to restart the server after changing this setting.
        if ::Refinery::Pages.use_marketable_urls?
          app.routes.append do
            scope(:module => 'refinery') do
              get '*path', :to => 'pages#show'
            end
          end

          app.config.after_initialize do
            # Add any parts of routes as reserved words.
            route_paths = app.routes.named_routes.routes.map{|name, route| route.path}
            ::Refinery::Page.friendly_id_config.reserved_words |= route_paths.map { |path|
              path.to_s.gsub(/^\//, '').to_s.split('(').first.to_s.split(':').first.to_s.split('/')
            }.flatten.reject{|w| w =~ /\_/}.uniq
          end
        end
      end

      config.to_prepare do |app|
        # You need to restart the server after changing this setting.
        if ::Refinery::Pages.use_marketable_urls?
          Rails.application.routes.append do
            scope(:module => 'refinery') do
              get '*path', :to => 'pages#show'
            end
          end

          Rails.application.config.after_initialize do
            # Add any parts of routes as reserved words.
            route_paths = Rails.application.routes.named_routes.routes.map{|name, route| route.path}
            ::Refinery::Page.friendly_id_config.reserved_words |= route_paths.map { |path|
              path.to_s.gsub(/^\//, '').to_s.split('(').first.to_s.split(':').first.to_s.split('/')
            }.flatten.reject{|w| w =~ /\_/}.uniq
          end
        end
        
        ::Refinery::Page.translation_class.send(:is_seo_meta)
        # set allowed attributes for mass assignment
        ::Refinery::Page.translation_class.send(:attr_accessible, :browser_title, :meta_description, :meta_keywords, :locale)
      end

      after_inclusion do
        ::ApplicationController.send :include, ::Refinery::Pages::InstanceMethods
        ::Refinery::AdminController.send :include, ::Refinery::Pages::Admin::InstanceMethods
      end

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_pages'
          plugin.directory = 'pages'
          plugin.version = %q{2.0.0}
          plugin.menu_match = /refinery\/page(_part)?s(_dialogs)?$/
          plugin.url = app.routes.url_helpers.refinery_admin_pages_path
          plugin.activity = {
            :class => ::Refinery::Page,
            :url_prefix => "edit",
            :title => "title",
            :created_image => "page_add.png",
            :updated_image => "page_edit.png"
          }
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Pages)
      end
    end
  end
end
