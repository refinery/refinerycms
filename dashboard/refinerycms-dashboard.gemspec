# Encoding: UTF-8
require File.expand_path('../../core/lib/refinery/version.rb', __FILE__)
version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-dashboard}
  s.version           = version
  s.summary           = %q{Dashboard engine for Refinery CMS}
  s.description       = %q{The dashboard is usually the first engine the user sees in the backend of Refinery CMS. It displays useful information and contains links to common functionality.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Resolve Digital', 'Philip Arndt', 'David Jones', 'Steven Heidel', 'Uģis Ozols']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)
  s.executables       = %w()

  s.add_dependency 'refinerycms-core', version
  
  s.files = Dir['license.md', 'app/**/*', 'config/**/*', 'lib/**/*', 'spec/**/*']
end
