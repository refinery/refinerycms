version = '0.9.9'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'refinerycms-images'
  s.version     = version
  s.summary     = 'Images engine for Refinery CMS'
  s.description = 'Ruby on Rails Images engine for Refinery CMS'
  s.required_ruby_version = '>= 1.8.7'

  s.email       = %q{info@refinerycms.com}
  s.homepage    = %q{http://refinerycms.com}
  s.authors     = ['Resolve Digital', 'David Jones', 'Philip Arndt']

  s.files       = Dir['**/*'] - Dir['*.gemspec']
  s.require_path = 'lib'

  s.add_dependency 'refinerycms-core', "~> #{version}"
  s.add_dependency 'dragonfly',        '~> 0.8.2'
  s.add_dependency 'rack-cache',       '~> 0.5.2'
end
