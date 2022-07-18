source 'https://rubygems.org'

ruby "3.1.2"
gemspec

gem 'rails', "~>6.1"
gem 'net-smtp', require: false
gem 'net-imap', require: false
gem 'net-pop', require: false


path "./" do
  gem "refinerycms-core"
  gem "refinerycms-dragonfly"
  gem "refinerycms-images"
  gem "refinerycms-pages"
  gem "refinerycms-resources"
end

gem 'refinerycms-i18n', git: 'https://github.com/anitagraham/refinerycms-i18n', branch: 'ruby3'

# Add support for refinerycms-acts-as-indexed
gem 'refinerycms-acts-as-indexed', ['~> 4.0', '>= 4.0.0'],
  git: 'https://github.com/refinery/refinerycms-acts-as-indexed',
  branch: 'master'

# Add the default visual editor, for now.
gem 'refinerycms-wymeditor', ['~> 3.0', '>= 3.0.0']

# Database Configuration
unless ENV['CI']
  gem 'activerecord-jdbcsqlite3-adapter', '>= 1.3.0.rc1', platform: :jruby
  gem 'sqlite3', platform: :ruby
end

if !ENV['CI'] || ENV['DB'] == 'mysql'
  group :mysql do
    gem 'activerecord-jdbcmysql-adapter', '>= 1.3.0.rc1', platform: :jruby
    gem 'mysql2', '~> 0.4', :platform => :ruby
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
  gem 'rspec-rails', '~> 6.0.0.rc1'
end

group :test do
  gem 'refinerycms-testing', path: './testing'
  gem 'generator_spec', '~> 0.9.3'
  gem 'launchy'
  gem 'coveralls', require: false
  gem 'rspec-retry'
  gem 'falcon'
  gem 'falcon-capybara'
end

# Load local gems according to Refinery developer preference.
eval_gemfile '.gemfile' if File.exist?('.gemfile')
