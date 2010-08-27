source 'http://rubygems.org'

gem 'rails',                    '3.0.0.rc2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby',             :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

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

# Specify the Engines to use:

gem 'refinerycms',              :path => '.'

# Specify additional Refinery CMS Engines here:
gem 'refinerycms-inquiries',    '~> 0.9.8.1', :require => 'inquiries'
# gem 'refinerycms-news',       '~> 0.9.8', :require => 'news'
# gem 'refinerycms-portfolio',  '~> 0.9.7', :require => 'portfolio'

# Add i18n support
gem 'refinerycms-i18n',         '~> 0.9.8', :require => 'refinery/i18n'
gem 'routing-filter'

# Add acts_as_tree support
gem 'acts_as_tree',             :git => 'git://github.com/parndt/acts_as_tree.git'

# Specify a version of RMagick that works in your environment:
gem 'rmagick',                  '~> 2.12.0', :require => false

# FIXME: These requirements are listed here temporarily pending a release
gem 'dragonfly',                :git => 'git://github.com/parndt/dragonfly.git',
                                :branch => 'refactor_job'

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
<<<<<<< HEAD
#===REFINERY END OF REQUIRED GEMS===

#===REQUIRED FOR REFINERY GEM INSTALL===
# Leave the gem below disabled (commented out) if you're not using the gem install method.
# gem 'refinerycms',    '~> 0.9.7.12'
#===END OF REFINERY GEM INSTALL REQUIREMENTS===

# Bundle gems for certain environments:
=======
>>>>>>> 40ef1ba81f6f9f5a595dfbe6f88ff8e19b5d22ea

# END REFINERY CMS DEVELOPMENT =================================================
