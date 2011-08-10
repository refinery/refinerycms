require 'rubygems'
require 'spork'

if RUBY_VERSION > "1.9"
  require "simplecov"
end

def setup_simplecov
  SimpleCov.start do
    Dir[File.expand_path('../../**/*.gemspec')].map{|g| g.split('/')[-2]}.each do |dir|
      add_group dir.capitalize, "#{dir}/"
    end
    %w(testing config spec vendor).each do |filter|
      add_filter "/#{filter}/"
    end
  end
end

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  
  # Configure Rails Environment
  ENV["RAILS_ENV"] ||= 'test'
  # simplecov should be loaded _before_ models, controllers, etc are loaded.
  setup_simplecov unless ENV["SKIP_COV"] || !defined?(SimpleCov)

  require File.expand_path("../../config/environment", __FILE__)
    
  require 'rspec/rails'
  require 'capybara/rspec'
  
  require 'refinery/testing/factories'
  require 'refinery/testing/controller_macros'
  require 'refinery/testing/request_macros'

  Rails.backtrace_cleaner.remove_silencers!

  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories including factories.
  ([Rails.root] | ::Refinery::Plugins.registered.pathnames).map{|p|
    Dir[p.join('spec', 'support', '**', '*.rb').to_s]
  }.flatten.sort.each do |support_file|
    require support_file
  end

  RSpec.configure do |config|
    config.mock_with :rspec
        
    # set javascript driver for capybara
    Capybara.javascript_driver = :webkit
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end

def capture_stdout(stdin_str = '')
  begin
    require 'stringio'
    $o_stdin, $o_stdout, $o_stderr = $stdin, $stdout, $stderr
    $stdin, $stdout, $stderr = StringIO.new(stdin_str), StringIO.new, StringIO.new
    yield
    {:stdout => $stdout.string, :stderr => $stderr.string}
  ensure
    $stdin, $stdout, $stderr = $o_stdin, $o_stdout, $o_stderr
  end
end
