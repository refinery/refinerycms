# Encoding: UTF-8
Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-<%= plural_name %>'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails <%= plural_name.titleize %> engine for Refinery CMS'
  s.date              = '<%= Time.now.strftime('%Y-%m-%d') %>'
  s.summary           = '<%= plural_name.titleize %> engine for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  s.add_development_dependency 'refinerycms-testing', '~> 2.0.0'
end
