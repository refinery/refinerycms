source 'https://rubygems.org'

gemspec

gem 'quiet_assets'
gem 'spring'
gem 'spring-commands-rspec'
gem 'poltergeist', '>= 1.8.1'

# Add support for refinerycms-acts-as-indexed
gem 'refinerycms-acts-as-indexed', ['~> 2.0', '>= 2.0.0']

# Add the default visual editor, for now.
gem 'refinerycms-wymeditor', ['~> 1.0', '>= 1.0.6']

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
  gem 'refinerycms-testing', '~> 3.0.0'
  gem 'generator_spec', '~> 0.9.3'
  gem 'launchy'
  gem 'coveralls', require: false
  gem 'rspec-retry'
end

# Load local gems according to Refinery developer preference.
if File.exist? local_gemfile = File.expand_path('../.gemfile', __FILE__)
  eval File.read(local_gemfile)
end
