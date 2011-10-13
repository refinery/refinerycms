# Encoding: UTF-8
require File.expand_path('../../core/lib/refinery/version.rb', __FILE__)
version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-images}
  s.version           = version
  s.summary           = %q{Images engine for Refinery CMS}
  s.description       = %q{Handles all image upload and processing functionality in Refinery CMS.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Resolve Digital', 'Philip Arndt', 'David Jones', 'Steven Heidel', 'Uģis Ozols']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)
  s.executables       = %w()

  s.add_dependency 'dragonfly',        '~> 0.9.8'
  s.add_dependency 'rack-cache',       '>= 0.5.3'
  s.add_dependency 'refinerycms-core', version
  
  s.files = Dir['license.md', 'app/**/*', 'config/**/*', 'db/**/*', 'lib/**/*', 'spec/**/*']
end
