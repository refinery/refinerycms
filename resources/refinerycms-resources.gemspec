require File.expand_path(File.join(*%w[.. .. lib refinery.rb]), __FILE__)
version = Refinery.version

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'refinerycms-resources'
  s.version     = version
  s.summary     = 'Resources engine for Refinery CMS'
  s.description = 'Ruby on Rails Resources engine for Refinery CMS'
  s.required_ruby_version = '>= 1.8.7'

  s.email       = %q{info@refinerycms.com}
  s.homepage    = %q{http://refinerycms.com}
  s.authors     = ['Resolve Digital', 'David Jones', 'Philip Arndt']

  s.files       = Dir['license.md', 'readme.md', 'lib/**/*', 'config/**/*', 'app/**/*']
  s.require_path = 'lib'

  s.add_dependency('refinerycms-base', version)
  s.add_dependency('refinerycms-core', version)
end
