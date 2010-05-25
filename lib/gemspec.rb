#!/usr/bin/env ruby
version = File.read(File.expand_path('../../VERSION', __FILE__)).strip
raise "Could not get version so gemspec can not be built" if version.nil?
files = %w( .gems .gitignore .yardopts Gemfile Rakefile readme.md license.md VERSION todo.md public/.htaccess )
%w(app bin config db lib public script test themes vendor).each do |dir|
  files += Dir.glob("#{dir}/**/*")
end

gemspec = <<EOF
Gem::Specification.new do |s|
  s.name              = %q{refinerycms}
  s.version           = %q{#{version}}
  s.description       = %q{A beautiful open source Ruby on Rails content manager for small business. Easy to extend, easy to use, lightweight and all wrapped up in a super slick UI.}
  s.date              = %q{#{Time.now.strftime('%Y-%m-%d')}}
  s.summary           = %q{A beautiful open source Ruby on Rails content manager for small business.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.authors           = %w(Resolve\ Digital David\ Jones Philip\ Arndt)
  s.require_paths     = %w(lib)
  s.executables       = %w(refinery refinery-update-core)

  s.files             = [
    '#{files.join("',\n\t\t'")}'
  ]
  s.test_files        = [
    '#{Dir.glob("test/**/*.rb").join("',\n\t\t'")}'
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
