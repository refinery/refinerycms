#version = File.read(File.expand_path("../../REFINERY_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'refinerycms-settings'
  s.version     = '1.0'
  s.summary     = 'File management functionality for the Refinery CMS project.'
  s.required_ruby_version = '>= 1.8.7'

  s.files        = Dir['changelog.md', 'README', 'MIT-LICENSE', 'lib/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true
end
