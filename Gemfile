# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# Allow CI and us to test specific Rails versions
gem 'rails', ENV['RAILS_VERSION'] if ENV['RAILS_VERSION']

# Ruby 3.4+ extracted mutex_m from stdlib, but older Rails versions need it
gem 'mutex_m' if RUBY_VERSION >= '3.4' && ENV['RAILS_VERSION']&.match?(/^~> [67]\./)

gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false

path './' do
  gem 'refinerycms-core'
  gem 'refinerycms-dragonfly'
  gem 'refinerycms-images'
  gem 'refinerycms-pages'
  gem 'refinerycms-resources'
end

gem 'refinerycms-i18n', github: 'refinery/refinerycms-i18n', branch: 'main'

# Add support for refinerycms-acts-as-indexed
gem 'refinerycms-acts-as-indexed', '~> 4.0', '>= 4.0.0',
  github: 'refinery/refinerycms-acts-as-indexed',
  branch: 'main'

# Add the default visual editor, for now.
gem 'refinerycms-wymeditor', ['~> 3.0', '>= 3.0.0']

# Work around Zeitwerk loading issues
gem 'decorators', github: 'parndt/decorators', branch: 'zeitwerk'

# Database Configuration
if !ENV['CI'] || ENV['DB'] == 'sqlite3'
  gem 'activerecord-jdbcsqlite3-adapter', '>= 1.3.0.rc1', platform: :jruby
  # Rails 6.1 and 7.0 require sqlite3 ~> 1.4, Rails 7.1+ can use newer versions
  if ENV['RAILS_VERSION']&.match?(/[67]\.[01]/)
    gem 'sqlite3', '~> 1.4.0', platform: :ruby
  else
    gem 'sqlite3', platform: :ruby
  end
end

if !ENV['CI'] || ENV['DB'] == 'mysql'
  group :mysql do
    gem 'activerecord-jdbcmysql-adapter', '>= 1.3.0.rc1', platform: :jruby
    gem 'mysql2', '~> 0.4', platform: :ruby
  end
end

if !ENV['CI'] || ENV['DB'] == 'postgresql'
  group :postgres, :postgresql do
    gem 'activerecord-jdbcpostgresql-adapter', '>= 1.3.0.rc1', platform: :jruby
    gem 'pg', '~> 1.1', platform: :ruby
  end
end

group :development, :test do
  gem 'activejob'
  gem 'bootsnap', require: false
  gem 'listen', '~> 3.0'
  gem 'puma', require: false
  gem 'rspec-rails'
end

group :test do
  gem 'generator_spec', '~> 0.9.3'
  gem 'launchy'
  gem 'refinerycms-testing', path: './testing'
  gem 'rspec-retry'
end

# Load local gems according to Refinery developer preference.
eval_gemfile '.gemfile' if File.exist?('.gemfile')
