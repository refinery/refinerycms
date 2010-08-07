# This file is used by Rack-based servers to start the application.
ENV["RAILS_ENV"] ||= "production"
require ::File.expand_path('../config/environment',  __FILE__)

# use Rack::ShowExceptions
# use Rack::Lint

run Refinery::Application
