source 'https://rubygems.org'

gemspec

gem 'rails', '~> 4.1.4'
gem 'friendly_id', '~> 5.0.0'
gem 'friendly_id-globalize', '>= 1.0.0.alpha1'
gem 'refinerycms-i18n', git: 'https://github.com/refinery/refinerycms-i18n', branch: 'master'
gem 'quiet_assets'
gem 'awesome_nested_set', git: 'https://github.com/collectiveidea/awesome_nested_set', branch: 'master'

# Add support for refinerycms-acts-as-indexed
gem 'refinerycms-acts-as-indexed', git: 'https://github.com/refinery/refinerycms-acts-as-indexed'

gem 'seo_meta', git: 'https://github.com/parndt/seo_meta', branch: 'master'

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
