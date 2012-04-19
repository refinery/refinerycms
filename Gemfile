source 'http://rubygems.org'

gemspec

# Add i18n support.
gem 'refinerycms-i18n', '~> 2.1.0.dev', :git => 'git://github.com/parndt/refinerycms-i18n.git'

# Fixes uniqueness constraint on translated columns.
# See: https://github.com/svenfuchs/globalize3/pull/121
gem 'globalize3', :git => 'git://github.com/svenfuchs/globalize3.git', :branch => 'master'

gem 'quiet_assets', :group => :development

# Database Configuration
unless ENV['TRAVIS']
  gem 'activerecord-jdbcsqlite3-adapter', :platform => :jruby
  gem 'sqlite3', :platform => :ruby
end

unless ENV['TRAVIS'] && ENV['DB'] != 'mysql'
  gem 'activerecord-jdbcmysql-adapter', :platform => :jruby
  gem 'mysql2', :platform => :ruby
end

unless ENV['TRAVIS'] && ENV['DB'] != 'postgresql'
  gem 'activerecord-jdbcpostgresql-adapter', :platform => :jruby
  gem 'pg', :platform => :ruby
end

gem 'jruby-openssl', :platform => :jruby

group :development, :test do
  gem 'refinerycms-testing', '~> 2.1.0.dev'
  gem 'generator_spec', '>= 0.8.5', :git => 'git://github.com/stevehodgkiss/generator_spec.git'
  gem 'guard-rspec', '~> 0.7.0'
  gem 'fuubar', '~> 1.0.0'

  platforms :mswin, :mingw do
    gem 'win32console', '~> 1.3.0'
    gem 'rb-fchange', '~> 0.0.5'
    gem 'rb-notifu', '~> 0.0.4'
  end

  platforms :ruby do
    gem 'spork', '~> 0.9.0'
    gem 'guard-spork', '~> 0.5.2'

    unless ENV['TRAVIS']
      require 'rbconfig'
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'rb-fsevent', '~> 0.9.0'
        gem 'ruby_gntp', '~> 0.3.4'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '~> 0.8.8'
        gem 'libnotify',  '~> 0.7.2'
        gem 'therubyracer', '~> 0.10.0'
      end
    end
  end

  platforms :jruby do
    unless ENV['TRAVIS']
      require 'rbconfig'
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'ruby_gntp', '~> 0.3.4'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '~> 0.8.8'
        gem 'libnotify',  '~> 0.7.2'
      end
    end
  end
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails', '~> 2.0.0'

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

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git', :branch => '3-1-stable'
# gem 'rack', :git => 'git://github.com/rack/rack.git'
# gem 'arel', :git => 'git://github.com/rails/arel.git'

# Load local gems according to Refinery developer preference.
if File.exist?(File.expand_path('../.gemfile', __FILE__))
  eval(File.read(File.expand_path('../.gemfile', __FILE__)))
end