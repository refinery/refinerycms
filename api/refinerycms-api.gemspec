# Encoding: UTF-8
require File.expand_path('../../core/lib/refinery/version', __FILE__)

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-api}
  s.version           = version
  s.summary           = %q{Api extension for Refinery CMS}
  s.description       = %q{Api extension for Refinery CMS}
  s.email             = %q{}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Brice Sanchez']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  # Runtime dependencies
  s.add_dependency             'refinerycms-core', version
  s.add_dependency             'graphql',          '~> 1.8', '>= 1.8.5'
  s.add_dependency             'graphiql-rails',   '~> 1.4'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '~> 4.0.0'

  s.required_ruby_version = Refinery::Version.required_ruby_version

  s.cert_chain  = [File.expand_path("../../certs/parndt.pem", __FILE__)]
  if $0 =~ /gem\z/ && ARGV.include?("build") && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem")
  end
end