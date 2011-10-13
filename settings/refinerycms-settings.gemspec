# Encoding: UTF-8
require File.expand_path('../../core/lib/refinery/version.rb', __FILE__)
version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-settings}
  s.version           = version
  s.summary           = %q{Settings engine for Refinery CMS}
  s.description       = %q{The default settings engine that is required by Refinery CMS core. Adds programmer creatable, user editable settings for each engine.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Resolve Digital', 'Philip Arndt', 'David Jones', 'Steven Heidel', 'Uģis Ozols']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)
  s.executables       = %w()
  
  s.files = Dir['license.md', 'app/**/*', 'config/**/*', 'db/**/*', 'lib/**/*', 'spec/**/*']
end
