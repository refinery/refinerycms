module Refinery
  module Core
    include ActiveSupport::Configurable

    config_accessor :rescue_not_found, :base_cache_key, :site_name,
                    :google_analytics_page_code, :matomo_analytics_server,
                    :matomo_analytics_site_id, :authenticity_token_on_frontend,
                    :javascripts, :stylesheets, :mounted_path,
                    :force_ssl, :backend_route,
                    :visual_editor_javascripts, :visual_editor_stylesheets,
                    :plugin_priority, :refinery_logout_path

    self.rescue_not_found = false
    self.base_cache_key = :refinery
    self.site_name = "Company Name"
    self.google_analytics_page_code = "UA-xxxxxx-x"
    self.matomo_analytics_server = "analytics.example.org"
    self.matomo_analytics_site_id = "123"
    self.authenticity_token_on_frontend = false
    self.javascripts = []
    self.stylesheets = []
    self.force_ssl = false
    self.backend_route = "refinery"
    self.mounted_path = "/"
    self.visual_editor_javascripts = []
    self.visual_editor_stylesheets = []
    self.plugin_priority = []

    def config.register_javascript(name)
      self.javascripts << name
    end

    def config.register_stylesheet(*args)
      self.stylesheets << Stylesheet.new(*args)
    end

    def config.register_visual_editor_javascript(name)
      self.visual_editor_javascripts << name
    end

    def config.register_visual_editor_stylesheet(*args)
      self.visual_editor_stylesheets << Stylesheet.new(*args)
    end

    class << self
      def backend_route
        # prevent / at the start.
        config.backend_route.to_s.gsub(%r{\A/}, '')
      end

      # See https://github.com/refinery/refinerycms/issues/2740
      def backend_path
        [mounted_path.gsub(%r{/\z}, ''), backend_route].join("/")
      end

      def clear_javascripts!
        self.javascripts = []
      end

      def clear_stylesheets!
        self.stylesheets = []
      end

      def dragonfly_custom_backend_class
        raise "Refinery::Dragonfly now handles all dragonfly configuration. Consult 'config/initializers/refinery/dragonfly.rb'."
      end

      def site_name
        ::I18n.t('site_name', :scope => 'refinery.core.config', :default => config.site_name)
      end

      def wymeditor_whitelist_tags=(tags)
        raise "Please ensure refinerycms-wymeditor is being used and use Refinery::Wymeditor.whitelist_tags instead of Refinery::Core.wymeditor_whitelist_tags"
      end
    end

    # wrapper for stylesheet registration
    class Stylesheet
      attr_reader :options, :path
      def initialize(*args)
        @options = args.extract_options!
        @path = args.first if args.first
      end
    end

  end
end
