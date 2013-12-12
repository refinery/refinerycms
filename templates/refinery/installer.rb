require 'rbconfig'
VERSION_BAND = '2.1.1'

# We want to ensure that you have an ExecJS runtime available!
begin
  require 'execjs'
rescue LoadError
  abort "ExecJS is not installed. Please re-start the installer after running:\ngem install execjs"
end

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
end

append_file 'Gemfile', <<-GEMFILE

# Refinery CMS
gem 'refinerycms', '~> #{VERSION_BAND}'

# Optionally, specify additional Refinery CMS Extensions here:
gem 'refinerycms-acts-as-indexed', '~> 1.0.0'
#  gem 'refinerycms-blog', '~> #{VERSION_BAND}'
#  gem 'refinerycms-inquiries', '~> #{VERSION_BAND}'
#  gem 'refinerycms-search', '~> #{VERSION_BAND}'
#  gem 'refinerycms-page-images', '~> #{VERSION_BAND}'
GEMFILE

begin
  require 'execjs'
  ::ExecJS::Runtimes.autodetect
rescue
  gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"
end

run 'bundle install'

rake 'db:create'
generate "refinery:cms --fresh-installation #{ARGV.join(' ')}"

say <<-SAY
  ============================================================================
    Your new Refinery CMS application is now installed and mounts at '/'
  ============================================================================
SAY
