# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Log level is set to :info by default which is the minimum to let you know what
# is going on but without being chatty and therefore slow.
config.log_level = :info

# When true will use Amazon's Simple Storage Service on your production machine
# instead of the default file system for resources and images
# Make sure to your bucket info is correct in amazon_s3.yml
Refinery.s3_backend = !(ENV['S3_KEY'].nil? || ENV['S3_SECRET'].nil?)
