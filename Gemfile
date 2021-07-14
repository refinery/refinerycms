source 'https://rubygems.org'

gemspec

path "./" do
  gem "refinerycms-core"
  gem "refinerycms-images"
  gem "refinerycms-pages"
  gem "refinerycms-resources"
end

# routing-filter needs a newer release than version 0.6.3
gem 'refinerycms-i18n', github: 'refinery/refinerycms-i18n', branch: 'master'
gem 'routing-filter', github: 'svenfuchs/routing-filter', branch: 'master'

# Add support for refinerycms-acts-as-indexed
gem 'refinerycms-acts-as-indexed', ['~> 3.0', '>= 3.0.0']

# Add the default visual editor, for now.
gem 'refinerycms-wymeditor', ['~> 2.2', '>= 2.2.0']

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
end

group :test do
  gem 'refinerycms-testing', path: './testing'
  gem 'generator_spec', '~> 0.9.3'
  gem 'launchy'
  gem 'coveralls', require: false
  gem 'rspec-retry'
  gem 'puma'

  # TODO: Use beta source for Rails 6 support
  gem 'rspec-rails', '~> 4.0.0.beta3'
end

# Load local gems according to Refinery developer preference.
eval_gemfile '.gemfile' if File.exist?('.gemfile')
