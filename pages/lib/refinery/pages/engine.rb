module Refinery
  module Pages
    class Engine < ::Rails::Engine
      extend Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_pages

      config.autoload_paths += %W( #{config.root}/lib )

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_pages'
          plugin.menu_match = %r{refinery/page(_part|s_dialog)?s(/preview)?$}
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_pages_path }
        end

        ::ApplicationController.send :helper, Refinery::Pages::ContentPagesHelper
        Refinery::AdminController.send :helper, Refinery::Pages::ContentPagesHelper
      end

      after_inclusion do
        Refinery.include_once(::ApplicationController, Refinery::Pages::InstanceMethods)
        Refinery.include_once(Refinery::AdminController, Refinery::Pages::Admin::InstanceMethods)
      end

      initializer "refinery.pages append marketable routes"  do
        append_marketable_routes if Refinery::Pages.marketable_urls
      end

      initializer "add marketable route parts to reserved words" do
        add_route_parts_as_reserved_words if Refinery::Pages.marketable_urls
      end

      config.to_prepare do
        Rails.application.config.assets.precompile += %w(
          speakingurl.js
        )
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Pages)
        Rails.application.reload_routes!
      end

      protected

      def append_marketable_routes
        Refinery::Core::Engine.routes.append do
          get '*path', :to => 'pages#show', :as => :marketable_page
        end
      end

      # Add any parts of routes as reserved words.
      def add_route_parts_as_reserved_words
        ActiveSupport.on_load(:active_record) do
          # do not add routes with :allow_slug => true
          included_routes = Rails.application.routes.named_routes.to_a.reject{ |name, route| route.defaults[:allow_slug] }
          route_paths = included_routes.map { |name, route| route.path.spec }
          route_paths.reject! { |path| path.to_s =~ %r{^/(rails|refinery)}}
          Refinery::Pages.friendly_id_reserved_words |= route_paths.map { |path|
            path.to_s.gsub(%r{^/}, '').to_s.split('(').first.to_s.split(':').first.to_s.split('/')
          }.flatten.reject { |w| w =~ %r{_|\.} }.uniq
        end
      end
    end
  end
end
