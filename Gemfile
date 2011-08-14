source 'http://rubygems.org'

gemspec

# Use unicorn as the web server
# gem 'unicorn'
# gem 'mongrel'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug', :platform => :mri_18
# or in 1.9.x:
# gem 'ruby-debug19', :platform => :mri_19

# For Heroku/s3:
# gem 'fog'

# REFINERY CMS ================================================================
# Anything you put in here will be overridden when the app gets updated.

# gem 'refinerycms', '~> 2.0.0'
gem 'refinerycms-generators', '~> 2.0.0', :git => 'git://github.com/resolve/refinerycms-generators.git'
gem 'seo_meta', :git => 'git://github.com/parndt/seo_meta.git'
gem 'globalize3', :git => 'git://github.com/svenfuchs/globalize3.git'
gem 'awesome_nested_set', :git => 'git://github.com/collectiveidea/awesome_nested_set.git'

# END REFINERY CMS ============================================================

# REFINERY CMS DEVELOPMENT ====================================================

gem 'arel', '2.1.4' # 2.1.5 was broken. see https://github.com/rails/arel/issues/72
gem 'therubyracer'

group :development, :test do
  gem 'refinerycms-testing',    '~> 2.0.0'
  gem 'rcov', :platform => :mri_18
  gem 'simplecov', :platform => :mri_19
  gem 'capybara-webkit', :git => 'git://github.com/thoughtbot/capybara-webkit.git'
  gem 'spork', '0.9.0.rc9', :platforms => :ruby
  gem 'guard-spork', :platforms => :ruby
  # Guard::RSpec spec_paths option added in this commit. Specified because Gem has not been cut yet.
  gem 'guard-rspec', :git => "git://github.com/guard/guard-rspec.git", :branch => "23476db8d97ceae44f5d6efb51411e717645e76d"
end

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git', :branch => '3-1-stable'
# gem 'rack', :git => 'git://github.com/rack/rack.git'
# gem 'arel', :git => 'git://github.com/rails/arel.git'

if defined? JRUBY_VERSION
  gem 'activerecord-jdbcsqlite3-adapter',
      :git => 'git://github.com/nicksieger/activerecord-jdbc-adapter.git'
  gem 'jruby-openssl'
else
  gem 'sqlite3'
  gem 'mysql2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-rails', "~> 3.1.0.rc"
  gem 'uglifier'
end

gem 'jquery-rails'

# END REFINERY CMS DEVELOPMENT ================================================

# USER DEFINED

# Specify additional Refinery CMS Engines here (all optional):
# gem 'refinerycms-inquiries',    '~> 1.0'
# gem "refinerycms-news",         '~> 1.2'
# gem 'refinerycms-blog',         '~> 1.6'
# gem 'refinerycms-page-images',  '~> 1.0'

# Add i18n support (optional, you can remove this if you really want to).
gem 'refinerycms-i18n',           '~> 2.0.0', :git => 'git://github.com/parndt/refinerycms-i18n'
# END USER DEFINED
