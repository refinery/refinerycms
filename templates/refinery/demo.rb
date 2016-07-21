require 'rbconfig'

# We want to ensure that you have an ExecJS runtime available!
begin
  require 'execjs'
  ::ExecJS::RuntimeUnavailable
rescue LoadError
  abort <<-ERROR
\033[31m[ABORTING]\033[0m ExecJS is not installed. Please re-start the installer after running:\ngem install execjs
ERROR
end

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
end

append_file 'Gemfile' do
"
gem 'refinerycms', git: 'https://github.com/refinery/refinerycms', branch: 'master'

# Add support for refinerycms-acts-as-indexed
gem 'refinerycms-acts-as-indexed', ['~> 3.0', '>= 3.0.0']

# Add support for refinerycms-wymeditor
gem 'refinerycms-wymeditor', ['~> 1.0', '>= 1.0.6']

gem 'refinerycms-blog', git: 'https://github.com/refinery/refinerycms-blog', branch: 'master'
gem 'refinerycms-inquiries', git: 'https://github.com/refinery/refinerycms-inquiries', branch: 'master'
gem 'refinerycms-news', git: 'https://github.com/refinery/refinerycms-news', branch: 'master'
gem 'refinerycms-page-images', git: 'https://github.com/refinery/refinerycms-page-images', branch: 'master'
gem 'refinerycms-portfolio', git: 'https://github.com/refinery/refinerycms-portfolio', branch: 'master'
gem 'refinerycms-settings', git: 'https://github.com/refinery/refinerycms-settings', branch: 'master'
gem 'refinerycms-search', git: 'https://github.com/refinery/refinerycms-search', branch: 'master'
gem 'refinerycms-authentication-devise', '>= 1.0.4'
"
end

run 'bundle install'

rake 'db:create'
generate "refinery:cms --fresh-installation #{ARGV.join(' ')}"

run 'rails generate refinery:blog'
run 'rails generate refinery:inquiries'
run 'rails generate refinery:news'
run 'rails generate refinery:page_images'
run 'rails generate refinery:portfolio'
run 'rails generate refinery:settings'
run 'rails generate refinery:search'

rake 'db:migrate'
rake 'db:seed'

run "bin/rails runner \"Refinery::Authentication::Devise::User.new(:username => 'demo', :password => 'demo', :email => 'demo@example.org').create_first\""
