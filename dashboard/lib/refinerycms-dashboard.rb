module Refinery
  module Dashboard
    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_dashboard'
          plugin.url = app.routes.url_helpers.refinery_admin_dashboard_path
          plugin.menu_match = /refinery\/(refinery_)?dashboard$/
          plugin.directory = 'dashboard'
          plugin.version = %q{1.1.0}
          plugin.always_allow_access = true
          plugin.dashboard = true
        end
      end

    end
  end
end

::Refinery.engines << 'dashboard'
