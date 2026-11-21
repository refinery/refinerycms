# Encoding: UTF-8


Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-dragonfly}
  s.version           = '1.0.1'
  s.summary           = %q{Dragonfly interface for Refinery CMS}
  s.description       = %q{Allows Refinery to use dragonfly for file storage and processing}
  s.email             = %q{anita@joli.com.au}
  s.homepage          = %q{http://refinerycms.com}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Rob Yurkowski', 'Anita Graham']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'dragonfly', '~> 1.1'
  s.add_dependency 'dragonfly-s3_data_store'
end
