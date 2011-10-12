module Refinery
  module Pages
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery

      config.before_initialize do
        require 'pages/marketable_urls'
      end

      config.to_prepare do
        require 'pages/tabs'
        require 'pages/marketable_urls'
        ::Refinery::Page.translation_class.send(:is_seo_meta)
        # set allowed attributes for mass assignment
        ::Refinery::Page.translation_class.send(:attr_accessible, :browser_title, :meta_description, :meta_keywords, :locale)
      end

      refinery.after_inclusion do
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
        Refinery.engines << 'pages'
      end
    end
  end
end
