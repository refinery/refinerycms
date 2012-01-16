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
            :updated_image => "page_edit.png"
          }
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
    end
  end
end
