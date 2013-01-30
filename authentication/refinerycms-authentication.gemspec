# Encoding: UTF-8
$:.push File.expand_path('../../core/lib', __FILE__)
require 'refinery/version'

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-authentication}
  s.version           = version
  s.summary           = %q{Authentication extension for Refinery CMS}
  s.description       = %q{The default authentication extension for Refinery CMS}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Rob Yurkowski']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'refinerycms-core',  version
  s.add_dependency 'devise',            '~> 2.0.5'
  s.add_dependency 'orm_adapter',       '~> 0.0.7'
end
