require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Performance patch from http://dev.theconversation.edu.au/post/7100138372
if File.exists?(File.expand_path('../ideal_load_path'))
  order = File.open('config/ideal_load_path').lines.map(&:chomp)
  $LOAD_PATH.sort_by! {|x| order.index(x).to_i * -1 }
end

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module RefineryApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Your secret key for verifying the integrity of signed cookies.
    # If you change this key, all old signed cookies will become invalid!
    # Make sure the secret is at least 30 characters and all random,
    # no regular words or you'll be exposed to dictionary attacks.
    config.secret_token = '7eb8a07ed3b9ae6ff772bcfe846887671472193a5bd494fcf1a7e7e5b128e2b9b96dea74091044ce31f0c613b1b258b18483a75c4b05b6d42cec2f7ee2a3022e'

    config.session_store :cookie_store, :key => '_RefineryApp_session'

    # Use the database for sessions instead of the cookie-based default,
    # which shouldn't be used to store highly confidential information
    # (create the session table with "rails generate session_migration")
    # RefineryApp::Application.config.session_store :active_record_store
  end
end
