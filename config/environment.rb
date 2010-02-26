# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Refinery::Application.initialize! if Rails.version.to_f >= 3.0
