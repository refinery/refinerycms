source :rubygems

RSPEC_VERSION = '~> 2.0.0.beta.15'

# Specify the database driver as appropriate for your application (only one is necessary).
# Defaults to sqlite3. Don't remove any of these below in the core or gems won't install.
gem 'sqlite3-ruby', :require => 'sqlite3' #db_adapter=sqlite3
#gem 'mysql', :require => 'mysql' #db_adapter=mysql
#gem 'pg' #db_adapter=postgresql

# Specify your favourite web server (only one) - not required.
#gem 'unicorn', :group => :development
#gem 'mongrel', :group => :development

# Deploy with Capistrano
# gem 'capistrano'

# If you are using s3 you probably want this gem:
# gem 'aws-s3'

#===REFINERY REQUIRED GEMS===
#git 'git://github.com/rails/rails.git'

gem 'rails',          '3.0.0.beta4'
gem 'rmagick',        '~> 2.12.2', :require => 'RMagick'
gem 'rack-cache',     :require => 'rack/cache'
gem 'dragonfly',                  :git => 'git://github.com/myabc/dragonfly.git',        :branch => '1.9.2-fixes'
gem 'acts_as_indexed', '= 0.6.3'
gem 'authlogic',      '~> 2.1.5'
gem 'friendly_id',    '~> 3.0'
gem 'truncate_html',   '= 0.3.2', :require => 'truncate_html'
gem 'will_paginate',  '3.0.pre',:git => "git://github.com/mislav/will_paginate.git", :branch => 'rails3'

group :test do
  gem 'json_pure', :require => 'json/pure', :git => 'git://github.com/parndt/json.git', :branch => 'master'
  gem 'rspec',              RSPEC_VERSION
  gem 'rspec-core',         RSPEC_VERSION, :require => 'rspec/core'
  gem 'rspec-expectations', RSPEC_VERSION, :require => 'rspec/expectations'
  gem 'rspec-mocks',        RSPEC_VERSION, :require => 'rspec/mocks'
  gem 'rspec-rails',        RSPEC_VERSION
  gem 'factory_girl'
  gem 'test-unit', '= 1.2.3'

  gem 'cucumber-rails'
  gem 'capybara'
  gem 'factory_girl'
  gem 'database_cleaner'
  gem 'launchy'
end
#===REFINERY END OF REQUIRED GEMS===

#===REQUIRED FOR REFINERY GEM INSTALL===
# Leave the gem below disabled (commented out) if you're not using the gem install method.
#gem 'refinerycms',    '= 0.9.7.5'
#===END OF REFINERY GEM INSTALL REQUIREMENTS===

# Bundle gems for certain environments:

# Specify your application's gem requirements here. See the examples below:
# gem "refinerycms-news", "~> 0.9.7", :require => "news"
# gem "refinerycms-portfolio", "~> 0.9.3.8", :require => "portfolio"