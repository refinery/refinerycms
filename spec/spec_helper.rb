$VERBOSE = ENV['VERBOSE'] || false

require 'rubygems'

ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../') unless defined?(ENGINE_RAILS_ROOT)

# Configure Rails Environment
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rspec'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.filter_run :js => true if ENV['JS'] == 'true'
  config.filter_run :js => nil if ENV['JS'] == 'false'
  config.run_all_when_everything_filtered = true
end

Rails.cache.clear
ActiveSupport::Dependencies.clear
FactoryGirl.reload

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories including factories.
([ENGINE_RAILS_ROOT, Rails.root.to_s].uniq | Refinery::Plugins.registered.pathnames).map{|p|
  Dir[File.join(p, 'spec', 'support', '**', '*.rb').to_s]
}.flatten.sort.each do |support_file|
  require support_file
end
