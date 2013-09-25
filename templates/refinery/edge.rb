require 'rbconfig'

# We want to ensure that you have an ExecJS runtime available!
begin
  require 'execjs'
rescue LoadError
  abort "ExecJS is not installed. Please re-start the installer after running:\ngem install execjs"
end

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
end

append_file 'Gemfile' do
"
gem 'refinerycms', github: 'refinery/refinerycms', branch: 'master'
gem 'refinerycms-i18n', github: 'refinery/refinerycms-i18n', branch: 'master'
"
end

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
    Your new Refinery CMS application is now running on edge and mounted to /.
  ============================================================================
SAY
