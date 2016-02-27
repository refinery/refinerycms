# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-<%= extension_plural_name %>'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails <%= extension_plural_name.titleize %> extension for Refinery CMS'
  s.date              = '<%= Time.now.strftime('%Y-%m-%d') %>'
  s.summary           = '<%= extension_plural_name.titleize %> extension for Refinery CMS'
  s.authors           = <%= extension_authors %>
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',    '~> <%= Refinery::Version %>'
  s.add_dependency             'acts_as_indexed',     '~> 0.8.0'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '~> <%= Refinery::Version %>'
end
