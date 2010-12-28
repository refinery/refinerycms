source 'http://rubygems.org'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

if (java = RUBY_PLATFORM == 'java')
  gem 'activerecord-jdbcsqlite3-adapter', '>= 1.0.2', :platform => :jruby
else
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

# Use unicorn as the web server
# gem 'unicorn'
# gem 'mongrel'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
# or in 1.9.x:
# gem 'ruby-debug19'

# For Heroku/s3:
# gem 'aws-s3', :require => 'aws/s3'

# REFINERY CMS ================================================================

java = (RUBY_PLATFORM == 'java')

# Specify the Refinery CMS core:
gem 'refinerycms',              :path => '.'

gem 'friendly_id',              :git => 'git://github.com/parndt/friendly_id', :branch => 'globalize3'

# Specify additional Refinery CMS Engines here (all optional):
gem 'refinerycms-generators',   '~> 0.9.9', :git => 'git://github.com/resolve/refinerycms-generators.git'
# gem 'refinerycms-inquiries',    '~> 0.9.9.9'
# gem 'refinerycms-news',         '~> 0.9.9.6'
# gem 'refinerycms-portfolio',    '~> 0.9.9'
# gem 'refinerycms-theming',      '~> 0.9.9'
# gem 'refinerycms-search',       '~> 0.9.8'
# gem 'refinerycms-blog',         '~> 1.1'

# Add i18n support (optional, you can remove this if you really want to).
gem 'routing-filter',           :git => 'git://github.com/refinerycms/routing-filter.git'
gem 'refinerycms-i18n',         :git => 'git://github.com/resolve/refinerycms-i18n.git'

gem 'jruby-openssl' if java

gem 'authlogic',                :git => 'git://github.com/parndt/authlogic.git'

group :test do
  # RSpec
  gem 'rspec-rails',            '~> 2.3'
  # Cucumber
  gem 'capybara',               :git => 'git://github.com/parndt/capybara.git'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'launchy'
  gem 'gherkin'
  gem 'spork' unless Bundler::WINDOWS
  gem 'rack-test',              '~> 0.5.6'
  # FIXME: Update json_pure to 1.4.7 when it is released
  gem 'json_pure', "1.4.6a", :git => "git://github.com/flori/json.git", :ref => "2c0f8d"
  # Factory Girl
  gem 'factory_girl'
  gem "#{'j' if java}ruby-prof" unless defined?(RUBY_ENGINE) and RUBY_ENGINE == 'rbx'
  # Autotest
  gem 'autotest'
  gem 'autotest-rails'
  gem 'autotest-notification'
  # FIXME: Replace when new babosa gem is released
  gem 'babosa', '0.2.0',        :git => 'git://github.com/stevenheidel/babosa.git' if java
end

# END REFINERY CMS ============================================================

# REFINERY CMS DEVELOPMENT ====================================================

# END REFINERY CMS DEVELOPMENT =================================================
