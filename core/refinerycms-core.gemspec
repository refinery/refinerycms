# Encoding: UTF-8
require File.expand_path('../../core/lib/refinery/version', __FILE__)

version = Refinery::Version.to_s
rails_version = ['>= 3.1.11', '< 4.1']

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-core}
  s.version           = version
  s.summary           = %q{Core extension for Refinery CMS}
  s.description       = %q{The core of Refinery CMS. This handles the common functionality and is required by most extensions}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Rob Yurkowski']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'refinerycms-i18n',            '~> 3.0.0.dev'
  s.add_dependency 'awesome_nested_set',          '~> 3.0.0.rc.1'
  s.add_dependency 'railties',                    rails_version
  s.add_dependency 'activerecord',                rails_version
  s.add_dependency 'actionpack',                  rails_version
  s.add_dependency 'truncate_html',               '~> 0.9'
  s.add_dependency 'will_paginate',               '~> 3.0.2'
  s.add_dependency 'sass-rails',                  '~> 4.0.0'
  s.add_dependency 'coffee-rails',                '~> 4.0.0'
  s.add_dependency 'jquery-rails',                '>= 2.3.0'
  s.add_dependency 'decorators',                  '~> 1.0.0'
end
