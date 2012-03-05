module Refinery
  module Pages
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_pages

      config.autoload_paths += %W( #{config.root}/lib )

      config.to_prepare do |app|
        Refinery::Page.translation_class.send(:is_seo_meta)
        Refinery::Page.translation_class.send(:attr_accessible, :browser_title, :meta_description, :meta_keywords, :locale)
      end

      before_inclusion do
        ::ApplicationController.send :helper, Refinery::Pages::ContentPagesHelper
        Refinery::AdminController.send :helper, Refinery::Pages::ContentPagesHelper
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
          plugin.menu_match = %r{refinery/page(_part|s_dialog)?s$}
          plugin.activity = { :class_name => :'refinery/page' }
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_pages_path }
        end
      end

      initializer "append marketable routes", :after => :set_routes_reloader_hook do
        append_marketable_routes if Refinery::Pages.marketable_urls
      end

      initializer "add marketable route parts to reserved words", :after => :set_routes_reloader_hook do |app|
        add_route_parts_as_reserved_words(app) if Refinery::Pages.marketable_urls
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Pages)
      end

    protected

      def append_marketable_routes
        Refinery::Core::Engine.routes.append do
          get '*path', :to => 'pages#show', :as => :marketable_page
        end
        Rails.application.routes_reloader.reload!
      end

      # Add any parts of routes as reserved words.
      def add_route_parts_as_reserved_words(app)
        route_paths = app.routes.named_routes.routes.map { |name, route| route.path.spec }
        route_paths.reject! {|path| path.to_s =~ %r{^/(rails|refinery)}}
        Refinery::Page.friendly_id_config.reserved_words |= route_paths.map { |path|
          path.to_s.gsub(%r{^/}, '').to_s.split('(').first.to_s.split(':').first.to_s.split('/')
        }.flatten.reject { |w| w =~ %r{_|\.} }.uniq
      end
    end
  end
end
