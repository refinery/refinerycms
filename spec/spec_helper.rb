$VERBOSE = ENV['VERBOSE'] || false

require 'rubygems'

ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../') unless defined?(ENGINE_RAILS_ROOT)

# Configure Rails Environment
ENV["RAILS_ENV"] ||= 'test'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rspec'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.filter_run :focus => true
  config.filter_run :js => true if ENV['JS'] == 'true'
  config.filter_run :js => nil if ENV['JS'] == 'false'
  config.run_all_when_everything_filtered = true
  config.include ActionView::TestCase::Behavior, :file_path => %r{spec/presenters}
  config.infer_spec_type_from_file_location!

  config.before(:each) do
    ::I18n.default_locale = I18n.locale = Globalize.locale = :en
  end
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories including factories.
([ENGINE_RAILS_ROOT, Rails.root.to_s].uniq | Refinery::Plugins.registered.pathnames).map{ |p|
  Dir[File.join(p, 'spec', 'support', '**', '*.rb').to_s]
}.flatten.sort.each do |support_file|
  require support_file
end

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, debug: false, js_errors:  true, inspector: :open)
end

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.always_include_port = true
