source 'http://rubygems.org'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails'

if RUBY_PLATFORM == 'java'
  gem 'activerecord-jdbcsqlite3-adapter', '>= 1.0.2', :platform => :jruby
else
  gem 'sqlite3'
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

# Specify the Refinery CMS core:
gem 'refinerycms',              :path => '.'

group :development, :test do
  # RSpec
  gem 'rspec-rails',            '= 2.3'
  # Cucumber
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'launchy'
  gem 'gherkin'
  gem 'spork' unless Bundler::WINDOWS
  gem 'rack-test',              '~> 0.5.6'
  gem 'json_pure'
  # Factory Girl
  gem 'factory_girl'
  gem "#{'j' if RUBY_PLATFORM == 'java'}ruby-prof" unless defined?(RUBY_ENGINE) and RUBY_ENGINE == 'rbx'
  # Autotest
  gem 'autotest'
  gem 'autotest-rails'
  gem 'autotest-notification'
end

# END REFINERY CMS ============================================================

# REFINERY CMS DEVELOPMENT ====================================================

# END REFINERY CMS DEVELOPMENT =================================================

# USER DEFINED

# Specify additional Refinery CMS Engines here (all optional):
gem 'refinerycms-generators',   '~> 0.9'
# gem 'refinerycms-inquiries',    '~> 0.9.9.9'
# gem 'refinerycms-news',         '~> 1.0'
# gem 'refinerycms-portfolio',    '~> 0.9.9'
# gem 'refinerycms-theming',      '~> 0.9.9'
# gem 'refinerycms-search',       '~> 0.9.8'
# gem 'refinerycms-blog',         '~> 1.1'

# Add i18n support (optional, you can remove this if you really want to).
gem 'refinerycms-i18n',         '~> 0.9'

# END USER DEFINED
