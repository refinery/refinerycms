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
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'David Jones', 'Steven Heidel']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.add_dependency 'devise',            '~> 2.0.0'
  s.add_dependency 'refinerycms-core',  version
end
