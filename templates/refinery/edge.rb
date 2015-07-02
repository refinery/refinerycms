# We want to ensure that you have an ExecJS runtime available!
begin
  require 'execjs'
  begin
    ::ExecJS::Runtimes.autodetect
  rescue
    gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"
  end
rescue LoadError
  abort <<-ERROR
\033[31m[ABORTING]\033[0m ExecJS is not installed. Please re-start the installer after running:\ngem install execjs
ERROR
end

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
end

refinerycms_source = if ENV['REFINERY_PATH']
  "path: '#{ENV['REFINERY_PATH']}'"
else
  "git: 'https://github.com/refinery/refinerycms', branch: 'master'"
end

append_file 'Gemfile' do
"
gem 'refinerycms', #{refinerycms_source}

# Add support for searching inside Refinery's admin interface.
gem 'refinerycms-acts-as-indexed', ['~> 3.0', '>= 3.0.0']

# Add support for Refinery's custom fork of the visual editor WYMeditor.
gem 'refinerycms-wymeditor', ['~> 2.0', '>= 2.0.0']

# The default authentication adapter
gem 'refinerycms-authentication-devise', '~> 2.0'
"
end

run 'bundle install'

rake 'db:create'
require 'refinery/core/environment_checker'
Refinery::Core::EnvironmentChecker.new(destination_root).call
generate "refinery:cms --fresh-installation #{ARGV.join(' ')}"

say <<-SAY
  ============================================================================
    Your new Refinery CMS application is now running on edge and mounted at '/'
  ============================================================================
SAY
