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


append_file 'Gemfile' do
"
gem 'refinerycms', git: 'https://github.com/refinery/refinerycms', branch: 'master'

# Add support for refinery_acts-as-indexed
gem 'refinery_acts-as-indexed', ['~> 3.0', '>= 3.0.0']

# Add support for refinery_wymeditor
gem 'refinery_wymeditor', ['~> 1.0', '>= 1.0.6']

gem 'refinery_blog', git: 'https://github.com/refinery/refinery_blog', branch: 'master'
gem 'refinery_inquiries', git: 'https://github.com/refinery/refinery_inquiries', branch: 'master'
gem 'refinery_news', git: 'https://github.com/refinery/refinery_news', branch: 'master'
gem 'refinery_page-images', git: 'https://github.com/refinery/refinery_page-images', branch: 'master'
gem 'refinery_portfolio', git: 'https://github.com/refinery/refinery_portfolio', branch: 'master'
gem 'refinery_settings', git: 'https://github.com/refinery/refinery_settings', branch: 'master'
gem 'refinery_search', git: 'https://github.com/refinery/refinery_search', branch: 'master'
gem 'refinery_authentication-devise', '>= 1.0.4'
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
