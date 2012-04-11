# Encoding: UTF-8
$:.push File.expand_path('../../core/lib', __FILE__)
require 'refinery/version'

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-core}
  s.version           = version
  s.summary           = %q{Core extension for Refinery CMS}
  s.description       = %q{The core of Refinery CMS. This handles the common functionality and is required by most extensions}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'David Jones', 'Steven Heidel']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'acts_as_indexed',             '~> 0.7.7'
  s.add_dependency 'friendly_id',                 '~> 4.0.1'
  s.add_dependency 'globalize3',                  '~> 0.2.0'
  s.add_dependency 'awesome_nested_set',          '~> 2.1.3'
  s.add_dependency 'rails',                       ['>= 3.1.3', '< 3.3']
  s.add_dependency 'truncate_html',               '~> 0.5'
  s.add_dependency 'will_paginate',               '~> 3.0.2'
  s.add_dependency 'sass-rails',                  '~> 3.2.3'
  s.add_dependency 'coffee-rails',                '~> 3.2.1'
  s.add_dependency 'uglifier',                    '>= 1.0.3'
  s.add_dependency 'jquery-rails',                '~> 2.0.0'
end
