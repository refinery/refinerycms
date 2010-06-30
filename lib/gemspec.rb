#!/usr/bin/env ruby
version = File.read(File.expand_path('../../VERSION', __FILE__)).strip
raise "Could not get version so gemspec can not be built" if version.nil?
files = %w( .gitignore .yardopts Gemfile Rakefile readme.md license.md VERSION todo.md public/.htaccess config.ru )
%w(app bin config db features lib public script test themes vendor).sort.each do |dir|
  files += Dir.glob("#{dir}/**/*")
end
=begin
File.readlines(File.expand_path('../../.gitignore', __FILE__)).each do |line|
  files.reject!{|f| f =~ Regexp.new(line)} rescue nil
end
=end
files.reject!{|f| !File.exist?(f) or f =~ /^(public\/system)|(config\/database.yml$)|(vendor\/cache)|(.+\.rbc)/}

gemspec = <<EOF
Gem::Specification.new do |s|
  s.name              = %q{refinerycms}
  s.version           = %q{#{version}}
  s.description       = %q{A beautiful open source Ruby on Rails content manager for small business. Easy to extend, easy to use, lightweight and all wrapped up in a super slick UI.}
  s.date              = %q{#{Time.now.strftime('%Y-%m-%d')}}
  s.summary           = %q{A beautiful open source Ruby on Rails content manager for small business.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.authors           = %w(Resolve\\ Digital David\\ Jones Philip\\ Arndt)
  s.require_paths     = %w(lib)
  s.executables       = %w(refinery refinery-update-core)

  s.files             = [
    '#{files.join("',\n    '")}'
  ]
  s.test_files        = [
    '#{Dir.glob("test/**/*.rb").join("',\n    '")}'
  ]
end
EOF

if (save = ARGV.delete('-s'))
  if File.exist?(file = "refinerycms.gemspec")
    File.delete(file)
  end
  File.open(file, 'w') { |f| f.puts gemspec }
else
  puts gemspec
end
