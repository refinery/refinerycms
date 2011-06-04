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

      initializer 'serve static assets' do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_settings'
          plugin.url = {:controller => '/admin/refinery_settings'}
          plugin.version = %q{1.0.0}
          plugin.menu_match = /(refinery|admin)\/(refinery_)?settings$/
        end
      end
    end
  end
end

::Refinery.engines << 'settings'
