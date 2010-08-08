Refinery::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = true
  # Warning: disabling this will means files in your public directly 
  # won't override core assets that are served from the plugin public directories.
  
  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  config.active_support.deprecation = :log

  config.after_initialize do
    # override translate, but only in production
    ::I18n.module_eval do
      class << self
        alias_method :original_rails_i18n_translate, :translate
        def translate(key, options = {})
          begin
            original_rails_i18n_translate(key, options.merge!({:raise => true}))
          rescue ::I18n::MissingTranslationData => e
            if self.config.locale != ::Refinery::I18n.default_locale
              self.translate(key, options.update(:locale => ::Refinery::I18n.default_locale))
            else
              raise e
            end
          end
        end
      end
    end
  end
end

# When true will use Amazon's Simple Storage Service on your production machine
# instead of the default file system for resources and images
# Make sure to your bucket info is correct in amazon_s3.yml
Refinery.s3_backend = !(ENV['S3_KEY'].nil? || ENV['S3_SECRET'].nil?)
