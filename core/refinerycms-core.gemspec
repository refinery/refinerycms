version = '0.9.9'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'refinerycms-core'
  s.version     = version
  s.summary     = 'Core engine for Refinery CMS'
  s.description = 'Ruby on Rails Core engine for Refinery CMS'
  s.required_ruby_version = '>= 1.8.7'

  s.email       = %q{info@refinerycms.com}
  s.homepage    = %q{http://refinerycms.com}
  s.authors     = ['Resolve Digital', 'David Jones', 'Philip Arndt']

  s.files        = Dir['**/*'] - Dir['*.gemspec']
  s.require_path = 'lib'

  s.add_dependency 'refinerycms-base',         '~> 0.9.9'
  s.add_dependency 'acts_as_indexed',          '~> 0.6.6'
  s.add_dependency 'friendly_id_globalize3',   '~> 3.2.0'
  s.add_dependency 'globalize3',               '>= 0.1.0.beta'
  s.add_dependency 'moretea-awesome_nested_set',  '= 1.4.3.1'
  s.add_dependency 'rails',                    '~> 3.0.3'
  s.add_dependency 'rdoc',                     '>= 2.5.11' # helps fix ubuntu
  s.add_dependency 'truncate_html',            '~> 0.5'
  s.add_dependency 'will_paginate',            '~> 3.0.pre'
  s.add_dependency 'refinerycms-settings',     "~> #{version}"
end
