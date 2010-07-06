ENV["RAILS_ENV"] ||= "production"
require File.expand_path("../config/application", __FILE__)

use Rails::Rack::LogTailer
use Rails::Rack::Static

run ActionController::Dispatcher.new