require File.expand_path('../boot', __FILE__)

# Specified gem version of Refinery to use when vendor/plugins/refinery/lib/refinery.rb is not present.
REFINERY_GEM_VERSION = '0.9.6.15' unless defined? REFINERY_GEM_VERSION

require 'pathname'
require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Refinerycms
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{config.root}/extras )

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure generators values. Many other options are available, be sure to check the documentation.
    # config.generators do |g|
    #   g.orm             :active_record
    #   g.template_engine :erb
    #   g.test_framework  :test_unit, :fixture => true
    # end

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password
  end
end

# pick the refinery root path
rails_root = (defined?(Rails.root) ? Rails.root : Pathname.new(Rails.root)).cleanpath
if (non_gem_path = rails_root.join("lib", "refinery_initializer.rb")).exist?
  require non_gem_path.to_s
else
  require 'rubygems'
  version = if defined? REFINERY_GEM_VERSION
    REFINERY_GEM_VERSION
  elsif ENV.include?("REFINERY_GEM_VERSION")
    ENV["REFINERY_GEM_VERSION"]
  else
    $1 if rails_root.join("config", "application.rb").read =~ /^[^#]*REFINERY_GEM_VERSION\s*=\s*["']([!~<>=]*\s*[\d.]+)["']/
  end

  if version
    gem 'refinerycms', version
  else
    gem 'refinerycms'
  end

  require 'refinery_initializer'
end

# Set to true in your environment specific file (e.g. production.rb) to use Amazon's Simple
# Storage Service instead of the default file system for resources and images
USE_S3_BACKEND = false unless defined?(USE_S3_BACKEND)

require Refinery.root.join("lib", "refinery_initializer").cleanpath.to_s
