# frozen_string_literal: true

require File.expand_path('core/lib/refinery/version', __dir__)

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms'
  s.version           = version
  s.description       = "A CMS for Ruby on Rails, supporting Rails 6+. It's developer friendly and easy to extend."
  s.summary           = 'A CMS for Ruby on Rails, supporting Rails 6+'
  s.email             = 'gems@p.arndt.io'
  s.homepage          = 'https://www.refinerycms.com'
  s.authors           = ['Philip Arndt', 'David Jones', 'Uģis Ozols', 'Brice Sanchez']
  s.license           = 'MIT'
  s.bindir            = 'exe'
  s.executables       = %w[refinerycms]
  s.require_paths     = %w[lib]

  s.files             = `git ls-files -- lib/* templates/*`.split("\n")

  s.add_dependency    'refinerycms-core',           version
  s.add_dependency    'refinerycms-images',         version
  s.add_dependency    'refinerycms-pages',          version
  s.add_dependency    'refinerycms-resources',      version
  s.required_ruby_version = Refinery::Version.required_ruby_version

  s.cert_chain = [File.expand_path('certs/parndt.pem', __dir__)]
  if $PROGRAM_NAME =~ /gem\z/ && ARGV.include?('build') && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')
  end
end
