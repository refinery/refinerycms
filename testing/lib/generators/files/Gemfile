source "http://rubygems.org"

gemspec

## Uncomment the following lines to develop against edge refinery
# gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'
# gem 'seo_meta', :git => 'git://github.com/parndt/seo_meta.git'

gem 'jquery-rails'

group :development, :test do
  gem 'refinerycms-testing', '~> 2.0.0'
  
  require 'rbconfig'
  
  platforms :mswin, :mingw do
    gem 'win32console'
    gem 'rb-fchange', '~> 0.0.5'
    gem 'rb-notifu', '~> 0.0.4'
  end

  platforms :ruby do
    gem 'spork', '0.9.0.rc9'
    gem 'guard-spork'
    
    if Config::CONFIG['target_os'] =~ /darwin/i
      gem 'rb-fsevent', '>= 0.3.9'
      gem 'growl',      '~> 1.0.3'
    end
    if Config::CONFIG['target_os'] =~ /linux/i
      gem 'rb-inotify', '>= 0.5.1'
      gem 'libnotify',  '~> 0.1.3'
    end
  end

  platforms :jruby do
    if Config::CONFIG['target_os'] =~ /darwin/i
      gem 'growl',      '~> 1.0.3'
    end
    if Config::CONFIG['target_os'] =~ /linux/i
      gem 'rb-inotify', '>= 0.5.1'
      gem 'libnotify',  '~> 0.1.3'
    end
  end
end

group :assets do
  gem 'sass-rails', "~> 3.1.0.rc.5"
  gem 'coffee-rails', "~> 3.1.0.rc.5"
  gem 'uglifier'
end

gem 'arel', '2.1.4' # 2.1.5 is broken. see https://github.com/rails/arel/issues/72
