module Refinery
  module Pages
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_pages

      config.autoload_paths += %W( #{config.root}/lib )

      before_inclusion do
        ::ApplicationController.send :helper, Refinery::Pages::ContentPagesHelper
        Refinery::AdminController.send :helper, Refinery::Pages::ContentPagesHelper
      end

      after_inclusion do
        Refinery.include_once(::ApplicationController, Refinery::Pages::InstanceMethods)
        Refinery.include_once(Refinery::AdminController, Refinery::Pages::Admin::InstanceMethods)
      end

      initializer "refinery.pages register plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_pages'
          plugin.version = %q{2.0.0}
          plugin.menu_match = %r{refinery/page(_part|s_dialog)?s$}
          plugin.activity = {
            :class_name => :'refinery/page',
            :nested_with => [:nested_url],
            :use_record_in_nesting => false
          }
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_pages_path }
        end
      end

      initializer "refinery.pages acts_as_indexed" do
        ActiveSupport.on_load(:active_record) do
          require 'acts_as_indexed'
          ActsAsIndexed.configure do |config|
            config.index_file = Rails.root.join('tmp', 'index')
            config.index_file_depth = 3
            config.min_word_size = 3
          end
        end
      end

      initializer "refinery.pages append marketable routes", :after => :set_routes_reloader_hook do
        append_marketable_routes if Refinery::Pages.marketable_urls
      end

      initializer "add marketable route parts to reserved words", :after => :set_routes_reloader_hook do
        add_route_parts_as_reserved_words if Refinery::Pages.marketable_urls
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
      def add_route_parts_as_reserved_words
        ActiveSupport.on_load(:active_record) do
          route_paths = Rails.application.routes.named_routes.routes.map { |name, route| route.path.spec }
          route_paths.reject! {|path| path.to_s =~ %r{^/(rails|refinery)}}
          Refinery::Page.friendly_id_config.reserved_words |= route_paths.map { |path|
            path.to_s.gsub(%r{^/}, '').to_s.split('(').first.to_s.split(':').first.to_s.split('/')
          }.flatten.reject { |w| w =~ %r{_|\.} }.uniq
        end
      end
    end
  end
end
