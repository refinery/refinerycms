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

      initializer "register refinery_pages plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_pages'
          plugin.version = %q{2.0.0}
          plugin.menu_match = /refinery\/page(_part)?s(_dialogs)?$/
          plugin.activity = {
            :class_name => :'refinery/page',
            :created_image => "page_add.png",
            :updated_image => "page_edit.png"
          }
          plugin.url = { :controller => '/refinery/admin/pages' }
        end
      end

      initializer "append marketable routes" do
        if Refinery::Pages.config.marketable_urls
          append_marketable_routes
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Pages)
      end

      protected

      def append_marketable_routes
        Refinery::Core::Engine.routes.append do
          get '*path', :to => 'pages#show'
        end
      end
    end
  end
end
