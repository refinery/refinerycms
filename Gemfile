source 'https://rubygems.org'

gemspec

path "./" do
  gem "refinerycms-core"
  gem "refinerycms-images"
  gem "refinerycms-pages"
  gem "refinerycms-resources"
end

gem 'spring'
gem 'spring-commands-rspec'
gem 'poltergeist', '>= 1.8.1'

# Add support for refinerycms-acts-as-indexed
gem 'refinerycms-acts-as-indexed', ['~> 3.0', '>= 3.0.0']


###########################
# Rails 5 temp. gem sources

gem 'refinerycms-i18n', github: 'refinery/refinerycms-i18n', branch: 'feature/rails-5'
gem 'routing-filter', github: 'svenfuchs/routing-filter', branch: 'master'
gem 'activemodel-serializers-xml'
gem 'globalize', github: 'pranik/globalize', branch: 'rails_5'
gem 'will_paginate', github: 'nmeylan/will_paginate', branch: 'master'

group :development do
  gem 'listen', '~> 3.0'
end

#
###########################


# Add the default visual editor, for now.
gem 'refinerycms-wymeditor', ['~> 1.0', '>= 1.0.6'],
  git: "https://github.com/parndt/refinerycms-wymeditor",
  branch: "bugfix/rails-5"

# Database Configuration
unless ENV['TRAVIS']
  gem 'activerecord-jdbcsqlite3-adapter', '>= 1.3.0.rc1', platform: :jruby
  gem 'sqlite3', platform: :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'mysql'
  group :mysql do
    gem 'activerecord-jdbcmysql-adapter', '>= 1.3.0.rc1', platform: :jruby
    gem 'mysql2', '~> 0.3.18', :platform => :ruby
  end
end

if !ENV['TRAVIS'] || ENV['DB'] == 'postgresql'
  group :postgres, :postgresql do
    gem 'activerecord-jdbcpostgresql-adapter', '>= 1.3.0.rc1', platform: :jruby
    gem 'pg', platform: :ruby
  end
end

group :test do
  gem 'refinerycms-testing', path: "./testing"
  gem 'generator_spec', '~> 0.9.3'
  gem 'launchy'
  gem 'coveralls', require: false
  gem 'rspec-retry'
end

# Load local gems according to Refinery developer preference.
if File.exist? local_gemfile = File.expand_path('../.gemfile', __FILE__)
  eval File.read(local_gemfile)
end
