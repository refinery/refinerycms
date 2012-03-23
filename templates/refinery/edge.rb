require 'rbconfig'

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

gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'

# USER DEFINED

# Specify additional Refinery CMS Engines here (all optional):
gem 'refinerycms-i18n', :git => 'git://github.com/parndt/refinerycms-i18n.git'
#  gem 'refinerycms-blog', :git => 'git://github.com/resolve/refinerycms-blog.git'
#  gem 'refinerycms-inquiries', :git => 'git://github.com/resolve/refinerycms-inquiries.git'
#  gem 'refinerycms-search', :git => 'git://github.com/resolve/refinerycms-search.git'
#  gem 'refinerycms-page-images', :git => 'git://github.com/resolve/refinerycms-page-images.git'

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
