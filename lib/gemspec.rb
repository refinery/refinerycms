#!/usr/bin/env ruby
require File.expand_path('../../vendor/plugins/refinery/lib/refinery.rb', __FILE__)
files = %w( .gitignore .yardopts Gemfile Rakefile *.md public/.htaccess config.ru ).map { |file| Dir[file] }.flatten
%w(app bin config db features lib public script test themes vendor).sort.each do |dir|
  files += Dir.glob("#{dir}/**/*")
end

files.reject!{|f| !File.exist?(f) or f =~ /^(public\/system)|(config\/database.yml$)|(.*\/cache)|(db\/.*\.sqlite3?$)|(\.log$)|(\.rbc$)/}

gemspec = <<EOF
Gem::Specification.new do |s|
  s.name              = %q{refinerycms}
  s.version           = %q{#{Refinery.version}}
  s.description       = %q{A beautiful open source Ruby on Rails content manager for small business. Easy to extend, easy to use, lightweight and all wrapped up in a super slick UI.}
  s.date              = %q{#{Time.now.strftime('%Y-%m-%d')}}
  s.summary           = %q{A beautiful open source Ruby on Rails content manager for small business.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.authors           = %w(Resolve\\ Digital David\\ Jones Philip\\ Arndt)
  s.require_paths     = %w(lib)
  s.executables       = %w(#{Dir.glob('bin/*').map{|d| d.gsub('bin/','')}.join(' ')})

  s.files             = [
    '#{files.join("',\n    '")}'
  ]
  s.test_files        = [
    '#{Dir.glob("test/**/*.rb").join("',\n    '")}'
  ]
end
EOF

File.open(File.expand_path("../../refinerycms.gemspec", __FILE__), 'w').puts(gemspec)
