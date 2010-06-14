source :rubygems

# Specify the database driver as appropriate for your application (only one).
gem 'mysql', :require => 'mysql'
#gem 'sqlite3-ruby', :require => 'sqlite3'

# Specify your favourite web server (only one).
gem 'unicorn', :group => :development
#gem 'mongrel', :group => :development

# Deploy with Capistrano
# gem 'capistrano'

# If you are using s3 you probably want this gem:
# gem 'aws-s3'

#===REFINERY REQUIRED GEMS===
gem 'acts_as_indexed', '= 0.6.2', :require => 'acts_as_indexed', :git => 'git://github.com/parndt/acts_as_indexed.git', :branch => 'master'
gem 'authlogic',       '= 2.1.5', :require => 'authlogic'
gem 'friendly_id',     '= 3.0.6', :require => 'friendly_id'
gem 'hpricot',         '= 0.8.2', :require => 'hpricot'
gem 'rails',           '= 2.3.8'
gem 'rmagick',         '~> 2.12.2'
gem 'will_paginate',   '= 2.3.14', :require => 'will_paginate'
#===REFINERY END OF REQUIRED GEMS===

#===REQUIRED FOR REFINERY GEM INSTALL===
# Leave the gem below disabled (commented out) if you're not using the gem install method.
#gem 'refinerycms',    '= 0.9.7.dev'
#===END OF REFINERY GEM INSTALL REQUIREMENTS===

# Bundle gems for certain environments:
group :cucumber do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
end

# Specify your application's gem requirements here. See the examples below:
# gem "refinerycms-news", "~> 0.9.7", :require => "news"
# gem "refinerycms-portfolio", "~> 0.9.3.8", :require => "portfolio"