require 'rbconfig'
append_file 'Gemfile' do
"
#{"gem 'therubyracer'" if RbConfig::CONFIG['target_os'] =~ /linux/i}

# remove this after i18n-js gets past version 2.1.2
gem 'i18n-js', :git => 'git://github.com/fnando/i18n-js.git'

gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'

#  group :development, :test do
#    gem 'refinerycms-testing', '~> 2.0'
#  end

# USER DEFINED

# Add i18n support (optional, you can remove this if you really want to but it is advised to keep it).
gem 'refinerycms-i18n',   '~> 2.0.0', :git => 'git://github.com/parndt/refinerycms-i18n.git'

# Specify additional Refinery CMS Engines here (all optional):
#  gem 'refinerycms-blog', :git => 'git://github.com/resolve/refinerycms-blog.git', :branch => 'rails-3-1'
#  gem 'refinerycms-inquiries', :git => 'git://github.com/resolve/refinerycms-inquiries.git', :branch => 'rails-3-1'
#  gem 'refinerycms-search', :git => 'git://github.com/resolve/refinerycms-search.git', :branch => 'rails-3-1'
#  gem 'refinerycms-page-images', :git => 'git://github.com/resolve/refinerycms-page-images.git', :branch => 'rails-3-1'

# END USER DEFINED
"
end

run 'bundle install'
rake 'db:create'
generate 'refinery:cms'
generate 'refinery:core'
generate 'refinery:pages'
generate 'refinery:images'
generate 'refinery:resources'
generate 'refinery:i18n'

rake 'railties:install:migrations'
rake 'db:migrate'

remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'

say <<-eos
  ============================================================================
          Your new RefineryCMS application is now running on edge.
  ============================================================================
eos
