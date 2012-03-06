# Encoding: UTF-8
$:.push File.expand_path('../../core/lib', __FILE__)
require 'refinery/version'

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-resources}
  s.version           = version
  s.summary           = %q{Resources extension for Refinery CMS}
  s.description       = %q{Handles all file upload and processing functionality in Refinery CMS.}
  s.date              = %q{2011-10-12}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'David Jones', 'Steven Heidel']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'dragonfly',        '~> 0.9.8'
  s.add_dependency 'rack-cache',       '>= 0.5.3'
  s.add_dependency 'refinerycms-core', version
end
