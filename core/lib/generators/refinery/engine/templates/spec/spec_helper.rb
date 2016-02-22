# Configure Rails Environment
ENV["RAILS_ENV"] ||= 'test'

if File.exist?(dummy_path = File.expand_path('../dummy/config/environment.rb', __FILE__))
  require dummy_path
elsif File.dirname(__FILE__) =~ %r{vendor/extensions}
  # Require the path to the refinerycms application this is vendored inside.
  require File.expand_path('../../../../../config/environment', __FILE__)
else
  puts "Could not find a config/environment.rb file to require. Please specify this in #{File.expand_path(__FILE__)}"
end

require 'rspec/rails'
require 'capybara/rspec'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories including factories.
([Rails.root.to_s] | ::Refinery::Plugins.registered.pathnames).map{ |p|
  Dir[File.join(p, 'spec', 'support', '**', '*.rb').to_s]
}.flatten.sort.each do |support_file|
  require support_file
end
