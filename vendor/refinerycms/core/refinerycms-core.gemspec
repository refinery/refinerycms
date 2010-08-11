#version = File.read(File.expand_path("../../REFINERY_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'refinerycms-core'
  s.version     = '0.9.8'
  s.summary     = 'Core functionality for the Refinery CMS project.'
  s.required_ruby_version = '>= 1.8.7'

  s.files        = Dir['changelog.md', 'README', 'MIT-LICENSE', 'lib/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('rails',           '>= 3.0.0.rc')
  s.add_dependency('acts_as_indexed', '= 0.6.3')
  s.add_dependency('friendly_id',     '~> 3.0')
  s.add_dependency('truncate_html',   '= 0.3.2')
  s.add_dependency('will_paginate',   '>= 3.0.pre2')
end
