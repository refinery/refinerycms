require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  
  # Configure Rails Environment
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
    
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'factory_girl'

  Rails.backtrace_cleaner.remove_silencers!

  Dir[
    File.expand_path("../support/**/*.rb", __FILE__),
    File.expand_path("../factories/**/*.rb", __FILE__)
  ].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = false
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end
