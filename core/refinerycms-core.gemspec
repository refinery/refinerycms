# frozen_string_literal: true

require File.expand_path('../core/lib/refinery/version', __dir__)

version = Refinery::Version.to_s
rails_version = ['>= 6.0.0', '< 7']

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-core'
  s.version           = version
  s.summary           = 'Core extension for Refinery CMS'
  s.description       = 'The core of Refinery CMS. This handles the common functionality and is required by most extensions'
  s.email             = 'gems@p.arndt.io'
  s.homepage          = 'https://www.refinerycms.com'
  s.authors           = ['Philip Arndt', 'David Jones', 'Uģis Ozols', 'Brice Sanchez']
  s.license           = 'MIT'
  s.require_paths     = %w[lib]

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.required_ruby_version = Refinery::Version.required_ruby_version

  s.add_dependency 'actionpack',                  rails_version
  s.add_dependency 'activerecord',                rails_version
  s.add_dependency 'coffee-rails',                ['~> 5.0', '>= 5.0.0']
  s.add_dependency 'decorators',                  '~> 2.0', '>= 2.0.0'
  s.add_dependency 'font-awesome-sass',           '>= 4.3.0', '< 5.0'
  s.add_dependency 'jquery-rails',                '~> 4.3', '>= 4.3.1'
  s.add_dependency 'jquery-ui-rails',             '~> 6.0', '>= 6.0.0'
  s.add_dependency 'railties',                    rails_version
  s.add_dependency 'refinerycms-i18n',            ['~> 5.0', '>= 5.0.1']
  s.add_dependency 'sass-rails',                  '>= 4.0', '< 7'
  s.add_dependency 'truncate_html',               '~> 0.9'
  s.add_dependency 'will_paginate',               '~> 3.1', '>= 3.1.0'
  s.add_dependency 'zilch-authorisation',         '~> 0', '>= 0.0.1'

  s.cert_chain = [File.expand_path('../certs/parndt.pem', __dir__)]
  if $PROGRAM_NAME =~ /gem\z/ && ARGV.include?('build') && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')
  end
end
