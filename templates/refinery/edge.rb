require 'rbconfig'

gsub_file 'Gemfile', "gem 'jquery-rails'", "gem 'jquery-rails', '>= 2.0.0'"

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
end

# We want to ensure that you have an ExecJS runtime available!
begin
  run 'bundle install'
  require 'execjs'
  ::ExecJS::Runtimes.autodetect
rescue
  gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"
end

append_file 'Gemfile' do
"

gem 'refinerycms', github: 'refinery/refinerycms', branch: 'master'

# USER DEFINED

# Specify additional Refinery CMS Engines here (all optional):
gem 'refinerycms-acts-as-indexed', github: 'refinery/refinerycms-acts-as-indexed', branch: 'master'
gem 'decorators', github: 'parndt/decorators', branch: 'master'
#  gem 'refinerycms-blog', github: 'refinery/refinerycms-blog', branch: 'master'
#  gem 'refinerycms-inquiries', github: 'refinery/refinerycms-inquiries', branch: 'master'
#  gem 'refinerycms-search', github: 'refinery/refinerycms-search', branch: 'master'
#  gem 'refinerycms-page-images', github: 'refinery/refinerycms-page-images', branch: 'master'

# END USER DEFINED
"
end

run 'bundle install'
rake 'db:create'
generate "refinery:cms --fresh-installation #{ARGV.join(' ')}"

say <<-eos
  ============================================================================
    Your new Refinery CMS application is now running on edge and mounted to /.
  ============================================================================
eos
