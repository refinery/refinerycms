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
      isolate_namespace ::Refinery::Settings

      initializer 'serve static assets' do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_settings"
          plugin.url = app.routes.url_helpers.refinery_admin_refinery_settings_path
          plugin.version = %q{0.9.9.21}
          plugin.menu_match = /(refinery|admin)\/(refinery_)?settings$/
        end
      end
    end
  end
end

::Refinery.engines << 'settings'
