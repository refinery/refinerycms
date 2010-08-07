source :rubygems

RSPEC_VERSION = '~> 2.0.0.beta.19'

# Specify the database driver as appropriate for your application (only one is necessary).
# Defaults to sqlite3. Don't remove any of these below in the core or gems won't install.
gem 'sqlite3-ruby', :require => 'sqlite3' # db_adapter=sqlite3
# gem 'mysql' # db_adapter=mysql
# gem 'pg'    # db_adapter=postgresql

# Specify your favourite web server (only one) - not required.
# gem 'unicorn', :group => :development
# gem 'mongrel', :group => :development

# Deploy with Capistrano
# gem 'capistrano'

# If you are using s3 you probably want this gem:
# gem 'aws-s3'

# REFINERY CMS ================================================================
# Use the default Refinery CMS Engines:
gem 'refinerycms',      :path => '.'

# Alternatively, cherry-pick the Refinery CMS Engines you wish to use:
# gem 'refinerycms-authentication'
# gem 'refinerycms-dashboard'
# gem 'refinerycms-inquiries'
# gem 'refinerycms-images'
# gem 'refinerycms-pages'
# gem 'refinerycms-resources'
# gem 'refinerycms-settings'
# gem 'refinerycms-theming'

# Specify additional Refinery CMS Engines here:
# gem 'refinerycms-news',       '~> 0.9.8', :require => 'news'
# gem 'refinerycms-portfolio',  '~> 0.9.7', :require => 'portfolio'

# Specify a version of RMagick that works in your environment:
gem 'rmagick',          '~> 2.12.0'

# FIXME: These requirements are listed here temporarily pending a release
gem 'dragonfly',        :git => 'git://github.com/myabc/dragonfly.git',
                        :branch => '1.9.2-fixes'
gem 'will_paginate',    '3.0.pre2',
                        :git => "git://github.com/mislav/will_paginate.git",
                        :branch => 'rails3'
# REFINERY CMS ================================================================

group :test do
  gem 'json_pure',      '= 1.4.5', :require => 'json/pure'

  gem 'rspec',              RSPEC_VERSION
  gem 'rspec-core',         RSPEC_VERSION, :require => 'rspec/core'
  gem 'rspec-expectations', RSPEC_VERSION, :require => 'rspec/expectations'
  gem 'rspec-mocks',        RSPEC_VERSION, :require => 'rspec/mocks'
  gem 'rspec-rails',        RSPEC_VERSION
  gem 'test-unit',      '= 1.2.3'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork' unless RUBY_PLATFORM =~ /mswin|mingw/
  gem 'launchy'
  gem 'gherkin'
  gem 'factory_girl'
  gem 'ruby-prof'
end
