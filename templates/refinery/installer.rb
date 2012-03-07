require 'rbconfig'
VERSION_BAND = '2.0.0'
append_file 'Gemfile' do
"

# Refinery CMS
gem 'refinerycms', '~> #{VERSION_BAND}'

# Specify additional Refinery CMS Extensions here (all optional):
gem 'refinerycms-i18n',   '~> #{VERSION_BAND}'
gem 'paper_trail'

#  gem 'refinerycms-blog', '~> #{VERSION_BAND}'
#  gem 'refinerycms-inquiries', '~> #{VERSION_BAND}'
#  gem 'refinerycms-search', '~> #{VERSION_BAND}'
#  gem 'refinerycms-page-images', '~> #{VERSION_BAND}'
"
end

run 'bundle install'
rake 'db:create'
run 'bundle exec rails generate paper_trail:install'
generate "refinery:cms --fresh-installation #{ARGV.join(' ')}"

say <<-eos
  ============================================================================
    Your new Refinery CMS application is now installed and mounts at '/'
  ============================================================================
eos
