# Settings specified here will take precedence over those in config/environment.rb
config.reload_plugins = true

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.log_level = :debug

# Uncomment the following lines if you're getting
# "A copy of XX has been removed from the module tree but is still active!"
# or you want to develop a plugin and don't want to restart every time a change is made:
=begin
config.after_initialize do
  ::ActiveSupport::Dependencies.load_once_paths = ::ActiveSupport::Dependencies.load_once_paths.select do |path|
    (path =~ /app/).nil?
  end
end
=end
