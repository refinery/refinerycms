# Ideal ->
# rails new app_name -m http://refinerycms.com/latest.rb
# Pratical -> 
# rails new app_name -m https://raw.github.com/gist/1237830/cda5dfb7459092ee41f2f77816812d844f6e3005/gistfile1.rb
gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'
run 'bundle install'
generate 'refinery:cms' 
rake 'db:migrate'

# Could easily add options for each engine during installation
# if yes?("Do you want to use RefineryCMS - Testing?")
#   gem 'refinerycms-testing', '~> 2.0'
#   run 'bundle install refinerycms-testing' 
#   run 'refinery:testing'
#   run 'rake'
# end

# if yes?("Do you want to use RefineryCMS - Blog?")
#   gem 'refinerycms-blog', :git => "git://github.com/resolve/refinerycms-blog.git", :branch => "rails-3-1"
#   run 'bundle install refinerycms-blog' 
#   generate 'refinery:blog'
#   rake 'db:migrate'
# end

# if yes?("Do you want to use RefineryCMS - Inquiries?")
#   gem 'refinerycms-inquiries', :git => "git://github.com/resolve/refinerycms-inquiries.git", :branch => "rails-3-1"
#   run 'bundle install refinerycms-inquiries' 
#   generate 'refinery:inquiries'
#   rake 'db:migrate'
# end

# if yes?("Do you want to use RefineryCMS - Search?")
#   gem 'refinerycms-search', :git => "git://github.com/resolve/refinerycms-search.git", :branch => "rails-3-1"
#   run 'bundle install refinerycms-search' 
# end

# if yes?("Do you want to use RefineryCMS - Page-Images?")
#   gem 'refinerycms-page-images', :git => "git://github.com/resolve/refinerycms-page-images.git", :branch => "rails-3-1"
#   run 'bundle install refinerycms-page-images' 
#   generate 'refinery:page_images'
#   rake 'db:migrate'
# end

remove_file 'public/index.html'
remove_file 'rm public/images/rails.png'

say <<-eos
  ============================================================================
          Your new RefineryCMS application is now running on edge.
  ============================================================================
eos
