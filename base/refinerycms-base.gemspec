require File.expand_path('../lib/refinery', __FILE__)

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'refinerycms-base'
  s.version     = ::Refinery::Version.to_s
  s.summary     = 'Base engine for Refinery CMS'
  s.description = 'Ruby on Rails Base engine for Refinery CMS'
  s.required_ruby_version = '>= 1.8.7'

  s.email       = %q{info@refinerycms.com}
  s.homepage    = %q{http://refinerycms.com}
  s.authors     = ['Resolve Digital', 'David Jones', 'Philip Arndt']

  s.files       = Dir['**/*'] - Dir['*.gemspec']
  s.require_path = 'lib'
end
