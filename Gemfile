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
gem 'selenium-webdriver', require: false

# Add support for refinerycms-acts-as-indexed
gem 'refinerycms-acts-as-indexed', ['~> 3.0', '>= 3.0.0']

# Add the default visual editor, for now.
gem 'refinerycms-wymeditor', ['~> 2.0', '>= 2.0.0']

# Database Configuration
unless ENV['TRAVIS']
  gem 'activerecord-jdbcsqlite3-adapter', '>= 1.3.0.rc1', platform: :jruby
  gem 'sqlite3', platform: :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'mysql'
  group :mysql do
    gem 'activerecord-jdbcmysql-adapter', '>= 1.3.0.rc1', platform: :jruby
    gem 'mysql2', '~> 0.4', :platform => :ruby
  end
end

if !ENV['TRAVIS'] || ENV['DB'] == 'postgresql'
  group :postgres, :postgresql do
    gem 'activerecord-jdbcpostgresql-adapter', '>= 1.3.0.rc1', platform: :jruby
    gem 'pg', '~> 0.21', platform: :ruby
  end
end

group :development do
  gem 'listen', '~> 3.0'
end

group :test do
  gem 'refinerycms-testing', path: './testing'
  gem 'generator_spec', '~> 0.9.3'
  gem 'launchy'
  gem 'coveralls', require: false
  gem 'rspec-retry'
  gem 'puma'
end

# Load local gems according to Refinery developer preference.
eval_gemfile '.gemfile' if File.exist?('.gemfile')
