require 'refinerycms-base'

module Refinery
  module Settings

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery

      initializer 'serve static assets' do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_settings'
          plugin.url = app.routes.url_helpers.refinery_admin_settings_path
          plugin.version = %q{1.1.0}
          plugin.menu_match = /(refinery|admin)\/settings$/
        end
      end
    end
  end
end

::Refinery.engines << 'settings'
