require 'rbconfig'
append_file 'Gemfile' do
"
#{"gem 'therubyracer'" if RbConfig::CONFIG['target_os'] =~ /linux/i}
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

# temporary devise hack
append_file 'config/application.rb' do
  "require 'devise/orm/active_record'"
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

mount = %Q{
  #  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will go to Refinery::PagesController#home.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Refinery relies on it being the default of "refinery"
  mount Refinery::Core::Engine => '/'
}

inject_into_file 'config/routes.rb', mount, :after => "Application.routes.draw do\n"

gsub_file 'config/application.rb', "require 'devise/orm/active_record'", ""

remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'


say <<-eos
  ============================================================================
    Your new RefineryCMS application is now running on edge and mounted to /.
  ============================================================================
eos
