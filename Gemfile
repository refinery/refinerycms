source :rubygems

# Specify the database driver as appropriate for your application (only one).
gem 'mysql', :require => 'mysql'
gem 'sqlite3-ruby', :require => 'sqlite3'

# Specify your favourite web server (only one).

# Deploy with Capistrano
# gem 'capistrano'

# If you are using s3 you probably want this gem:
# gem 'aws-s3'

#===REFINERY REQUIRED GEMS===
#git 'git://github.com/rails/rails.git'

gem 'rails',          '3.0.0.beta4'
gem 'rmagick',        '~> 2.13.1', :require => 'RMagick'
gem 'rack-cache',     :require => 'rack/cache'
gem 'dragonfly'
gem 'hpricot',        '~> 0.8'
gem 'authlogic',      '~> 2.1.5'
gem 'friendly_id',    '~> 3.0'
gem 'will_paginate',  '3.0.pre', :git => "git://github.com/mislav/will_paginate.git", :branch => 'rails3'
#===REFINERY END OF REQUIRED GEMS===

#===REQUIRED FOR REFINERY GEM INSTALL===
# Leave the gem below disabled (commented out) if you're not using the gem install method.
#gem 'refinerycms',    '= 0.9.7.dev'
#===END OF REFINERY GEM INSTALL REQUIREMENTS===

# Bundle gems for certain environments:
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'rspec-rails'
end


# Specify your application's gem requirements here. See the examples below:
# gem "refinerycms-news", "~> 0.9.7", :require => "news"
# gem "refinerycms-portfolio", "~> 0.9.3.8", :require => "portfolio"

