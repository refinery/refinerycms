# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-<%= plural_name %>'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails <%= plural_name.titleize %> forms-engine for Refinery CMS'
  s.date              = '<%= Time.now.strftime('%Y-%m-%d') %>'
  s.summary           = '<%= plural_name.titleize %> forms-engine for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir['lib/**/*', 'config/**/*', 'app/**/*']

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',    '~> <%= Refinery::Version %>'

  # Development dependencies (usually to test the application with)
  s.add_development_dependency 'refinerycms-testing', '~> <%= Refinery::Version %>'
end
