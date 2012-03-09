# Encoding: UTF-8
$:.push File.expand_path('../../core/lib', __FILE__)
require 'refinery/version'

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-testing}
  s.version           = version
  s.summary           = %q{Testing plugin for Refinery CMS}
  s.description       = %q{This plugin adds the ability to run cucumber and rspec against the Refinery CMS gem while inside a Refinery CMS project}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")

  s.add_dependency 'refinerycms-core',        version
  s.add_dependency 'database_cleaner',        '~> 0.7.1'
  s.add_dependency 'factory_girl_rails',      '~> 1.7.0'
  s.add_dependency 'rack-test',               '~> 0.6.0'
  s.add_dependency 'rspec-rails',             '~> 2.8.1'
  s.add_dependency 'capybara',                '~> 1.1.0'
end
