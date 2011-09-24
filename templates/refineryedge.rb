# Ideal ->
# rails new app_name -m http://refinerycms.com/latest.rb
# Pratical -> 
# rails new app_name -m https://raw.github.com/gist/1237830/cda5dfb7459092ee41f2f77816812d844f6e3005/gistfile1.rb
gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'
run 'bundle install'

generate 'refinery:cms' 
rake 'db:migrate'

remove_file 'public/index.html'
remove_file 'rm public/images/rails.png'

# Could easily add options for each engine during installation
# if yes?("Do you want to use RefineryCMS - Testing?")
#   gem 'refinerycms-testing', '~> 1.0.4'
#   run 'refinery:testing'
#   run 'rake'
# end

say <<-eos
  ============================================================================
          Your new RefineryCMS application is now running on edge.
  ============================================================================
eos
