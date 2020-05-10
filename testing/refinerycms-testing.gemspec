# frozen_string_literal: true

require File.expand_path('../core/lib/refinery/version', __dir__)

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-testing'
  s.version           = version
  s.summary           = 'Testing plugin for Refinery CMS'
  s.description       = 'This plugin adds the ability to tests against the Refinery CMS gem while inside a Refinery CMS extension'
  s.email             = 'gems@p.arndt.io'
  s.homepage          = 'https://www.refinerycms.com'
  s.authors           = ['Philip Arndt', 'David Jones', 'Uģis Ozols', 'Brice Sanchez']
  s.license           = 'MIT'
  s.require_paths     = %w[lib]

  s.files             = `git ls-files`.split("\n")

  s.add_dependency 'capybara',                '>= 2.18'
  s.add_dependency 'factory_bot_rails',       '~> 4.8'
  s.add_dependency 'rails-controller-testing', '>= 0.1.1'
  s.add_dependency 'refinerycms-core', version
  s.add_dependency 'rspec-rails', '~> 4.0.0.beta2'
  s.add_dependency 'webdrivers', '~> 4.0'

  s.required_ruby_version = Refinery::Version.required_ruby_version

  s.cert_chain = [File.expand_path('../certs/parndt.pem', __dir__)]
  if $PROGRAM_NAME =~ /gem\z/ && ARGV.include?('build') && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')
  end
end
