source 'http://rubygems.org'

gemspec

# REFINERY CMS ================================================================
# Anything you put in here will be overridden when the app gets updated.

# gem 'refinerycms', '~> 2.0.0'

# END REFINERY CMS ============================================================

# REFINERY CMS DEVELOPMENT ====================================================

# Database Configuration
platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'activerecord-jdbcmysql-adapter'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'jruby-openssl'
end

unless defined?(JRUBY_VERSION)
  gem 'sqlite3'
  gem 'mysql2'
  gem 'pg'
end

group :development, :test do
  gem 'refinerycms-testing', '~> 2.0.0'
  gem 'generator_spec'

  platforms :mri_18 do
    gem 'rcov'
  end

  platforms :mri_19 do
    gem 'simplecov'
  end

  platforms :mswin, :mingw do
    gem 'win32console'
    gem 'rb-fchange', '~> 0.0.5'
    gem 'rb-notifu', '~> 0.0.4'
  end

  platforms :ruby do
    gem 'spork', '~> 0.9.0.rc'
    gem 'guard-spork'

    unless ENV['TRAVIS']
      require 'rbconfig'
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'rb-fsevent', '>= 0.3.9'
        gem 'growl',      '~> 1.0.3'
        gem 'growl_notify'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '>= 0.5.1'
        gem 'libnotify',  '~> 0.1.3'
        gem 'therubyracer', '~> 0.9.9'
      end
    end
  end

  platforms :jruby do
    unless ENV['TRAVIS']
      require 'rbconfig'
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'growl',      '~> 1.0.3'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '>= 0.5.1'
        gem 'libnotify',  '~> 0.1.3'
      end
    end
  end
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.0'
  gem 'coffee-rails', '~> 3.2.0'
  gem 'uglifier'
end

gem 'jquery-rails', '~> 2.0.0'

# END REFINERY CMS DEVELOPMENT ================================================

# USER DEFINED

# Specify additional Refinery CMS Engines here (all optional):
# gem 'refinerycms-inquiries',    '~> 1.0'
# gem "refinerycms-news",         '~> 1.2'
# gem 'refinerycms-blog',         '~> 1.6'
# gem 'refinerycms-page-images',  '~> 1.0'

# Add i18n support (optional, you can remove this if you really want to).
gem 'refinerycms-i18n',           :git => 'git://github.com/parndt/refinerycms-i18n.git'
# END USER DEFINED

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
