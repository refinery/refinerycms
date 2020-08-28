# frozen_string_literal: true

require File.expand_path('../core/lib/refinery/version', __dir__)

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-pages'
  s.version           = version
  s.summary           = 'Pages extension for Refinery CMS'
  s.description       = 'The default content extension of Refinery CMS. This extension handles the administration and display of user-editable pages.'
  s.email             = 'gems@p.arndt.io'
  s.homepage          = 'https://www.refinerycms.com'
  s.authors           = ['Philip Arndt', 'David Jones', 'Uģis Ozols', 'Brice Sanchez']
  s.license           = 'MIT'
  s.require_paths     = %w[lib]

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'awesome_nested_set',          '~> 3.1', '>= 3.1.0'
  s.add_dependency 'babosa',                      '~> 1.0'
  s.add_dependency 'diffy',                       '~> 3.1', '>= 3.1.0'
  s.add_dependency 'friendly_id',                 ['>= 5.1.0', '< 5.3']
  s.add_dependency 'friendly_id-mobility',        '~> 0.5'
  s.add_dependency 'refinerycms-core',            version
  s.add_dependency 'seo_meta',                    '~> 3.0', '>= 3.0.0'
  s.add_dependency 'speakingurl-rails',           '~> 8.0', '>= 8.0.0'

  s.required_ruby_version = Refinery::Version.required_ruby_version

  s.cert_chain = [File.expand_path('../certs/parndt.pem', __dir__)]
  if $PROGRAM_NAME =~ /gem\z/ && ARGV.include?('build') && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')
  end
end
