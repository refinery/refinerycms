require 'rbconfig'
append_file 'Gemfile' do
"

gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'

# USER DEFINED

# Specify additional Refinery CMS Engines here (all optional):
gem 'refinerycms-i18n',   '~> 2.0.0', :git => 'git://github.com/parndt/refinerycms-i18n.git'
#  gem 'refinerycms-settings', :git => 'git://github.com/parndt/refinerycms-settings.git'
#  gem 'refinerycms-blog', :git => 'git://github.com/resolve/refinerycms-blog.git', :branch => 'rails-3-1'
#  gem 'refinerycms-inquiries', :git => 'git://github.com/resolve/refinerycms-inquiries.git', :branch => 'rails-3-1'
#  gem 'refinerycms-search', :git => 'git://github.com/resolve/refinerycms-search.git', :branch => 'rails-3-1'
#  gem 'refinerycms-page-images', :git => 'git://github.com/resolve/refinerycms-page-images.git', :branch => 'rails-3-1'

# END USER DEFINED
"
end

run 'bundle install'
rake 'db:create'
generate 'refinery:cms --fresh-installation #{ARGV.join(' ')}'

say <<-eos
  ============================================================================
    Your new Refinery CMS application is now running on edge and mounted to /.
  ============================================================================
eos
