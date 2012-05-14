# Encoding: UTF-8
$:.push File.expand_path('../../core/lib', __FILE__)
require 'refinery/version'

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-pages}
  s.version           = version
  s.summary           = %q{Pages extension for Refinery CMS}
  s.description       = %q{The default content extension of Refinery CMS. This extension handles the administration and display of user-editable pages.}
  s.date              = %q{2011-10-12}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Rob Yurkowski', 'David Jones', 'Steven Heidel']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'awesome_nested_set',          '~> 2.1.3'
  s.add_dependency 'seo_meta',                    '~> 1.3.0'
  s.add_dependency 'refinerycms-core',            version
  s.add_dependency 'babosa',                      '!= 0.3.6'
end
