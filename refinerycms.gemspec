# Encoding: UTF-8
$:.push File.expand_path('../core/lib', __FILE__)
require 'refinery/version'

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms}
  s.version           = version
  s.description       = %q{A Ruby on Rails CMS that supports Rails 3. It's easy to extend and sticks to 'the Rails way' where possible.}
  s.summary           = %q{A Ruby on Rails CMS that supports Rails 3}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Resolve Digital', 'Philip Arndt', 'David Jones', 'Steven Heidel', 'Uģis Ozols']
  s.license           = %q{MIT}
  s.bindir            = 'bin'
  s.executables       = %w(refinerycms)
  
  s.add_dependency    'bundler',                    '~> 1.0'
  s.add_dependency    'refinerycms-authentication', version
  s.add_dependency    'refinerycms-core',           version
  s.add_dependency    'refinerycms-dashboard',      version
  s.add_dependency    'refinerycms-images',         version
  s.add_dependency    'refinerycms-pages',          version
  s.add_dependency    'refinerycms-resources',      version
  s.add_dependency    'refinerycms-settings',       version
end
