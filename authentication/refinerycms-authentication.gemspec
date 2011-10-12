require File.expand_path('../../core/lib/refinery/version.rb', __FILE__)
version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-authentication}
  s.version           = version
  s.summary           = %q{Authentication engine for Refinery CMS}
  s.description       = %q{The default authentication engine for Refinery CMS}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Resolve Digital', 'Philip Arndt', 'David Jones', 'Steven Heidel', 'Uģis Ozols']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)
  s.executables       = %w()

  s.add_dependency 'devise',                      '~> 1.4.0'
  s.add_dependency 'friendly_id_globalize3',      '~> 3.2.1'
  s.add_dependency 'refinerycms-core',            version
  
  s.files = Dir['license.md', 'app/**/*', 'config/**/*', 'db/**/*', 'lib/**/*', 'spec/**/*']
end
