# Encoding: UTF-8
require File.expand_path('../../core/lib/refinery/version', __FILE__)

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-testing}
  s.version           = version
  s.summary           = %q{Testing plugin for Refinery CMS}
  s.description       = %q{This plugin adds the ability to tests against the Refinery CMS gem while inside a Refinery CMS extension}
  s.email             = %q{refinerycms@p.arndt.io}
  s.homepage          = %q{https://www.refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Rob Yurkowski']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")

  s.add_dependency 'refinerycms-core',        version
  s.add_dependency 'database_cleaner',        '~> 1.6'
  s.add_dependency 'factory_bot_rails',       '~> 4.8'
  s.add_dependency 'rspec-rails',             '~> 3.5'
  s.add_dependency 'capybara',                '~> 2.18'
  s.add_dependency 'rails-controller-testing', '~> 0.1.1'

  s.required_ruby_version = Refinery::Version.required_ruby_version

  s.cert_chain  = [File.expand_path("../../certs/parndt.pem", __FILE__)]
  if $0 =~ /gem\z/ && ARGV.include?("build") && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem")
  end
end
