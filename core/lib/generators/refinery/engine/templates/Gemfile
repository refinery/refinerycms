source "http://rubygems.org"

gemspec

gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'

# Database Configuration
platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'activerecord-jdbcmysql-adapter'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'jruby-openssl'
end

platforms :ruby do
  gem 'sqlite3'
  gem 'mysql2'
  gem 'pg'
end

group :development, :test do
  gem 'refinerycms-testing', :git => 'git://github.com/resolve/refinerycms.git'
  gem 'guard-rspec', '~> 0.7.0'

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
