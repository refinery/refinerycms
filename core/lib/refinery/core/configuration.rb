module Refinery
  module Core
    include ActiveSupport::Configurable

    config_accessor :rescue_not_found, :s3_backend, :base_cache_key, :site_name,
                    :google_analytics_page_code, :authenticity_token_on_frontend,
                    :dragonfly_secret,
                    :wymeditor_whitelist_tags, :javascripts, :stylesheets,
                    :s3_bucket_name, :s3_region, :s3_access_key_id,
                    :s3_secret_access_key, :force_ssl, :backend_route

    self.rescue_not_found = false
    self.s3_backend = false
    self.base_cache_key = :refinery
    self.site_name = "Company Name"
    self.google_analytics_page_code = "UA-xxxxxx-x"
    self.authenticity_token_on_frontend = false
    self.dragonfly_secret = Array.new(24) { rand(256) }.pack('C*').unpack('H*').first
    self.wymeditor_whitelist_tags = {}
    self.javascripts = []
    self.stylesheets = []
    self.s3_bucket_name = ENV['S3_BUCKET']
    self.s3_region = ENV['S3_REGION']
    self.s3_access_key_id = ENV['S3_KEY']
    self.s3_secret_access_key = ENV['S3_SECRET']
    self.force_ssl = false
    self.backend_route = "refinery"

    def config.register_javascript(name)
      self.javascripts << name
    end

    def config.register_stylesheet(*args)
      self.stylesheets << Stylesheet.new(*args)
    end

    class << self
      def clear_javascripts!
        self.javascripts = []
      end

      def clear_stylesheets!
        self.stylesheets = []
      end

      def site_name
        ::I18n.t('site_name', :scope => 'refinery.core.config', :default => config.site_name)
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
