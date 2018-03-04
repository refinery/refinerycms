# Encoding: UTF-8
require File.expand_path('../core/lib/refinery/version', __FILE__)

version = Refinery::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms}
  s.version           = version
  s.description       = %q{A Ruby on Rails CMS that supports Rails 5.1. It's developer friendly and easy to extend.}
  s.summary           = %q{A Ruby on Rails CMS that supports Rails 5.1}
  s.email             = %q{refinerycms@p.arndt.io}
  s.homepage          = %q{https://www.refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Rob Yurkowski']
  s.license           = %q{MIT}
  s.bindir            = 'exe'
  s.executables       = %w(refinerycms)
  s.require_paths     = %w(lib)

  s.files             = `git ls-files -- lib/* templates/*`.split("\n")

  s.add_dependency    'refinerycms-core',           version
  s.add_dependency    'refinerycms-images',         version
  s.add_dependency    'refinerycms-pages',          version
  s.add_dependency    'refinerycms-resources',      version
  s.required_ruby_version = Refinery::Version.required_ruby_version

  s.cert_chain  = [File.expand_path("../certs/parndt.pem", __FILE__)]
  if $0 =~ /gem\z/ && ARGV.include?("build") && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem")
  end
end
