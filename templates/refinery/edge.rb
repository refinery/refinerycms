gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'
run 'bundle install'
generate 'refinery:cms'
rake 'railties:install:migrations'
rake 'db:migrate'

append_file 'Gemfile' do
" #  group :development, :test do
  #    gem 'refinerycms-testing', '~> 2.0'
  #  end

  #   USER DEFINED

  # Specify additional Refinery CMS Engines here (all optional):
  #  gem 'refinerycms-blog', :git => 'git://github.com/resolve/refinerycms-blog.git', :branch => 'rails-3-1'
  #  gem 'refinerycms-inquiries', :git => 'git://github.com/resolve/refinerycms-inquiries.git', :branch => 'rails-3-1'
  #  gem 'refinerycms-search', :git => 'git://github.com/resolve/refinerycms-search.git', :branch => 'rails-3-1'
  #  gem 'refinerycms-page-images', :git => 'git://github.com/resolve/refinerycms-page-images.git', :branch => 'rails-3-1'

  #  END USER DEFINED"
end

remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'

say <<-eos
  ============================================================================
          Your new RefineryCMS application is now running on edge.
  ============================================================================
eos
