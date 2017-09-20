# Encoding: UTF-8
require File.expand_path('../../core/lib/refinery/version', __FILE__)

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-images}
  s.version           = version
  s.summary           = %q{Images extension for Refinery CMS}
  s.description       = %q{Handles all image upload and processing functionality in Refinery CMS.}
  s.email             = %q{refinerycms@p.arndt.io}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Rob Yurkowski']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'dragonfly',               '~> 1.1', '>= 1.1.0'
  s.add_dependency 'globalize',               ['>= 5.1.0.beta1', '< 5.2']
  s.add_dependency 'activemodel-serializers-xml', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'refinerycms-core',        version

  s.required_ruby_version = Refinery::Version.required_ruby_version

  s.cert_chain  = [File.expand_path("../../certs/parndt.pem", __FILE__)]
  if $0 =~ /gem\z/ && ARGV.include?("build") && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem")
  end
end
