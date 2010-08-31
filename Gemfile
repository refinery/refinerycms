source 'http://rubygems.org'
gem 'bundler',                  '~> 1.0.0'
gem 'rails',                    '3.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby',             :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'
# gem 'mongrel', :group => :development

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri', '1.4.1'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

# REFINERY CMS ================================================================

# Specify the Refinery CMS core:
gem 'refinerycms',              :path => '.'

# Specify additional Refinery CMS Engines here (all optional):
gem 'refinerycms-inquiries',    '~> 0.9.8.4', :require => 'inquiries'
# gem 'refinerycms-news',       '~> 0.9.8', :require => 'news'
# gem 'refinerycms-portfolio',  '~> 0.9.7', :require => 'portfolio'
# gem 'refinerycms-theming',    '~> 0.9.8', :require => 'theming'

# Add i18n support (optional, you can remove this if you really want to).
gem 'refinerycms-i18n',         '~> 0.9.8.3', :require => 'refinery/i18n'

# Specify a version of RMagick that works in your environment:
gem 'rmagick',                  '~> 2.12.0', :require => false

# END REFINERY CMS ============================================================

# REFINERY CMS DEVELOPMENT ====================================================

group :test do
  # RSpec
  gem 'rspec',                  (RSPEC_VERSION = '~> 2.0.0.beta')
  gem 'rspec-core',             RSPEC_VERSION, :require => 'rspec/core'
  gem 'rspec-expectations',     RSPEC_VERSION, :require => 'rspec/expectations'
  gem 'rspec-mocks',            RSPEC_VERSION, :require => 'rspec/mocks'
  gem 'rspec-rails',            RSPEC_VERSION
  # Cucumber
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork' unless RUBY_PLATFORM =~ /mswin|mingw/
  gem 'launchy'
  gem 'gherkin'
  # TODO: Change back to gem when patch is merged in
  gem 'rack-test',              :git => 'git://github.com/alan/rack-test.git'
  # FIXME: JSON constant constants warnings
  gem 'json_pure',              '~> 1.4.6', :require => 'json/pure'
  # Factory Girl
  gem 'factory_girl'
  gem 'ruby-prof'
  # Autotest
  gem 'autotest'
  gem 'autotest-rails'
  gem 'autotest-notification'
end

# END REFINERY CMS DEVELOPMENT =================================================
