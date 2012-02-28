require 'rbconfig'
VERSION_BAND = '2.0.0'
append_file 'Gemfile' do
"

# Refinery CMS
gem 'refinerycms', '~> #{VERSION_BAND}'

# Add i18n support to Refinery CMS (optional, you can remove this if you really want to but it is advised to keep it).
gem 'refinerycms-i18n',   '~> #{VERSION_BAND}'

# Specify additional Refinery CMS Extensions here (all optional):
#  gem 'refinerycms-blog', '~> #{VERSION_BAND}'
#  gem 'refinerycms-inquiries', '~> #{VERSION_BAND}'
#  gem 'refinerycms-search', '~> #{VERSION_BAND}'
#  gem 'refinerycms-page-images', '~> #{VERSION_BAND}'
"
end

run 'bundle install'
rake 'db:create'
generate 'refinery:cms --fresh-installation'

rake 'railties:install:migrations db:migrate'
rake 'db:seed'

say <<-eos
  ============================================================================
    Your new Refinery CMS application is now installed and mounts at '/'
  ============================================================================
eos
