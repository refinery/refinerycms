require 'rbconfig'
VERSION_BAND = '2.0.0'

# We want to ensure that you have an ExecJS runtime available!
begin
  run 'bundle install'
  require 'execjs'
  ::ExecJS::Runtimes.autodetect
rescue
  require 'pathname'
  if Pathname.new(destination_root.to_s).join('Gemfile').read =~ /therubyracer/
    gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"
  else
    append_file 'Gemfile', <<-GEMFILE

group :assets do
  # Added by Refinery. We want to ensure that you have an ExecJS runtime available!
  gem 'therubyracer'
end
GEMFILE
  end
end

append_file 'Gemfile', <<-GEMFILE

# Spam filter mixin for your models.
# https://github.com/resolve/filters_spam
# gem 'filters_spam', '~> 0.3'

# Refinery CMS
gem 'refinerycms', '~> #{VERSION_BAND}'

# Specify additional Refinery CMS Extensions here (all optional):
gem 'refinerycms-i18n', '~> #{VERSION_BAND}'
#  gem 'refinerycms-blog', '~> #{VERSION_BAND}'
#  gem 'refinerycms-inquiries', '~> #{VERSION_BAND}'
#  gem 'refinerycms-search', '~> #{VERSION_BAND}'
#  gem 'refinerycms-page-images', '~> #{VERSION_BAND}'
GEMFILE

run 'bundle install'
rake 'db:create'
generate "refinery:cms --fresh-installation #{ARGV.join(' ')}"

say <<-SAY
  ============================================================================
    Your new Refinery CMS application is now installed and mounts at '/'
  ============================================================================
SAY
