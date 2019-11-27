# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-dragonfly}
  s.version           = '1.0.2'
  s.summary           = %q{Dragonfly interface for Refinery CMS}
  s.description       = %q{Allows Refinery to use dragonfly for file storage and processing}
  s.email             = %q{anita@joli.com.au}
  s.homepage          = %q{http://refinerycms.com}
  s.authors           = ['Anita Graham', 'Philip Arndt']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'dragonfly', '~> 1.1'
  s.add_development_dependency 'dragonfly-s3_data_store'
  s.add_dependency 'refinerycms-core', ['~> 4.0', '>= 4.0.2']

  s.cert_chain  = [File.expand_path("../../certs/parndt.pem", __FILE__)]
  if $0 =~ /gem\z/ && ARGV.include?("build") && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem")
  end
end
