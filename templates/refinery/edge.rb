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

if ENV['REFINERY_PATH']
  append_file 'Gemfile' do
"
gem 'refinerycms', path: '#{ENV['REFINERY_PATH']}'
"
  end
else
  append_file 'Gemfile' do
"
gem 'refinerycms', git: 'https://github.com/refinery/refinerycms', branch: 'master'
"
  end
end

append_file 'Gemfile' do
"
# Add support for searching inside Refinery's admin interface.
gem 'refinerycms-acts-as-indexed', git: 'https://github.com/refinery/refinerycms-acts-as-indexed', branch: 'master'

# Add support for Refinery's custom fork of the visual editor WYMeditor.
gem 'refinerycms-wymeditor', git: 'https://github.com/parndt/refinerycms-wymeditor', branch: 'master'

# The default authentication adapter
gem 'refinerycms-authentication-devise', git: 'https://github.com/refinery/refinerycms-authentication-devise', branch: 'master'
"
end

run 'bundle install'

rake 'db:create'
generate "refinery:cms --fresh-installation #{ARGV.join(' ')}"

say <<-SAY
  ============================================================================
    Your new Refinery CMS application is now running on edge and mounted to /.
  ============================================================================
SAY
