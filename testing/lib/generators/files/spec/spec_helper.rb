require 'rubygems'

def setup_environment
  # Configure Rails Environment
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../dummy/config/environment.rb",  __FILE__)

  require 'rspec/rails'
  require 'capybara/rspec'
  require 'factory_girl_rails'

  Rails.backtrace_cleaner.remove_silencers!

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = false
  end
end

def each_run
  FactoryGirl.reload
  
  Dir[
    Rails.root.join('spec/support/**/*.rb'),
    Rails.root.join('spec/factories/**/*.rb')
  ].each { |f| require f }
end

# If spork is available in the Gemfile it'll be used but we don't force it.
unless (begin; require 'spork'; rescue LoadError; nil end).nil?
  Spork.prefork do
    # Loading more in this block will cause your tests to run faster. However,
    # if you change any configuration or code from libraries loaded here, you'll
    # need to restart spork for it take effect.
    setup_environment
  end

  Spork.each_run do
    # This code will be run each time you run your specs.
    each_run
  end
else
  setup_environment
  each_run
end
