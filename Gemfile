source 'https://rubygems.org'

gemspec

gem 'refinerycms-i18n', git: 'https://github.com/refinery/refinerycms-i18n', branch: 'master'
gem 'quiet_assets'

# Add support for refinerycms-acts-as-indexed
gem 'refinerycms-acts-as-indexed', ['~> 2.0', '>= 2.0.0']

# Add the default visual editor, for now.
gem 'refinerycms-wymeditor', ['~> 1.0', '>= 1.0.0']

# Database Configuration
unless ENV['TRAVIS']
  gem 'activerecord-jdbcsqlite3-adapter', '>= 1.3.0.rc1', platform: :jruby
  gem 'sqlite3', platform: :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'mysql'
  group :mysql do
    gem 'activerecord-jdbcmysql-adapter', '>= 1.3.0.rc1', platform: :jruby
    gem 'mysql2', :platform => :ruby
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
  gem 'generator_spec', '~> 0.9.1'
  gem 'launchy'
end

# Load local gems according to Refinery developer preference.
if File.exist? local_gemfile = File.expand_path('../.gemfile', __FILE__)
  eval File.read(local_gemfile)
end
