source :rubygems

# Specify the database driver as appropriate for your application (only one).
gem 'mysql', :require => 'mysql'
#gem 'sqlite3-ruby', :require => 'sqlite3'

# Specify your favourite web server (only one).
gem 'unicorn', :group => :development
#gem 'mongrel', :group => :development

# Deploy with Capistrano
# gem 'capistrano'

#===REFINERY REQUIRED GEMS===
gem 'rmagick',        '~> 2.13.1'
gem 'rails',          '~> 2.3.5'
gem 'hpricot',        '~> 0.8', :require => 'hpricot'
gem 'authlogic',      '~> 2.1.3', :require => 'authlogic'
gem 'friendly_id',    '~> 2.3.3', :require => 'friendly_id'
gem 'will_paginate',  '~> 2.3.12', :require => 'will_paginate'
# explicitly call require when in production, seems to fix a couple problems.
require 'will_paginate' if Rails.env.production?
#===REFINERY END OF REQUIRED GEMS===

#===REQUIRED FOR REFINERY GEM INSTALL===
# Leave the gem below disabled (commented out) if you're not using the gem install method.
#gem 'refinerycms',    '= 0.9.7.dev'
#===END OF REFINERY GEM INSTALL REQUIREMENTS===

# Bundle gems for certain environments:
group :test do
  # gem 'rspec',       '1.2.9'
  # gem 'rspec-rails', '1.2.9'
end

# Specify your application's gem requirements here. See the examples below:
# gem "refinerycms-news", "~> 0.9.7", :require => "news"
# gem "refinerycms-portfolio", "~> 0.9.3.8", :require => "portfolio"