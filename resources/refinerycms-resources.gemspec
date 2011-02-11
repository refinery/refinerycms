require File.expand_path('../../base/lib/refinery', __FILE__)

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'refinerycms-resources'
  s.version     = ::Refinery::Version.to_s
  s.summary     = 'Resources engine for Refinery CMS'
  s.description = 'Ruby on Rails Resources engine for Refinery CMS'
  s.required_ruby_version = '>= 1.8.7'

  s.email       = %q{info@refinerycms.com}
  s.homepage    = %q{http://refinerycms.com}
  s.authors     = ['Resolve Digital', 'David Jones', 'Philip Arndt']

  s.files       = Dir['**/*'] - Dir['*.gemspec']
  s.require_path = 'lib'

  s.add_dependency 'refinerycms-core', "~> #{::Refinery::Version}"
  s.add_dependency 'dragonfly',        '~> 0.8.2'
  s.add_dependency 'rack-cache',       '~> 0.5.2'
end
