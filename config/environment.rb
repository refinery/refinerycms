# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION
# Freeze to a specific version of refinerycms when running as a gem
# REFINERY_GEM_VERSION = '0.9.6' unless defined? REFINERY_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

eval("#{(defined? Refinery::Initializer) ? Refinery : Rails}::Initializer").run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :authentication, :acts_as_tree, :attachment_fu, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_refinery_session',
    :secret      => 'eec8fffc3637c05895f8e6a355179eaad0003ac5617e5368955baf7989e1faca4d8ab37140d690c20b05d5815609b7c680c644277b6a892be316a85c6596d75c'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  #

  # Please add your gems above the Refinery required gems here:

  #===REFINERY REQUIRED GEMS===
  config.gem "rake", :version => ">= 0.8.3", :lib => "rake"
	config.gem "rubyzip", :version => ">= 0.9.1", :lib => "zip/zip"
  config.gem "friendly_id", :version => ">= 2.2.2", :lib => "friendly_id"
  config.gem "will_paginate", :version => ">= 2.3.11", :lib => "will_paginate", :source => "http://gemcutter.org"
  config.gem "rails", :version => ">= 2.3.5", :lib => "rails"
  config.gem "aasm", :version => ">= 2.1.3", :lib => "aasm", :source => "http://gemcutter.org"
  config.gem "slim_scrooge", :version => ">= 1.0.3", :lib => "slim_scrooge", :source => "http://gemcutter.org" unless RUBY_PLATFORM =~ /mswin|mingw/ # kill gem when windows is running.
  config.gem "hpricot", :version => ">= 0.8.1", :lib => "hpricot", :source => "http://gemcutter.org"
  #===REFINERY END OF REQUIRED GEMS===
end