# Encoding: UTF-8
require File.expand_path('../../core/lib/refinery/version', __FILE__)

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-pages}
  s.version           = version
  s.summary           = %q{Pages extension for Refinery CMS}
  s.description       = %q{The default content extension of Refinery CMS. This extension handles the administration and display of user-editable pages.}
  s.email             = %q{refinerycms@p.arndt.io}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Rob Yurkowski']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'friendly_id',                 ['>= 5.1.0', '< 5.3']
  s.add_dependency 'globalize',                   ['>= 5.1.0.beta1', '< 5.2']
  s.add_dependency 'activemodel-serializers-xml', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'awesome_nested_set',          '~> 3.1', '>= 3.1.0'
  s.add_dependency 'seo_meta',                    '~> 3.0', '>= 3.0.0'
  s.add_dependency 'refinerycms-core',            version
  s.add_dependency 'babosa',                      '!= 0.3.6'
  s.add_dependency 'speakingurl-rails',           '~> 8.0', '>= 8.0.0'
  s.add_dependency 'diffy',                       '~> 3.1', '>= 3.1.0'

  s.required_ruby_version = Refinery::Version.required_ruby_version

  s.cert_chain  = [File.expand_path("../../certs/parndt.pem", __FILE__)]
  if $0 =~ /gem\z/ && ARGV.include?("build") && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem")
  end
end
