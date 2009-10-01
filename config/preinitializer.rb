# pick the refinery root path
if File.exist?("#{RAILS_ROOT}/lib/init.rb")
  REFINERY_ROOT = RAILS_ROOT
elsif File.exist?("#{RAILS_ROOT}/vendor/refinery")
  REFINERY_ROOT = "#{RAILS_ROOT}/vendor/refinery"
else
  require 'rubygems'
  version = if defined? REFINERY_GEM_VERSION
    REFINERY_GEM_VERSION
  elsif ENV.include?("REFINERY_GEM_VERSION")
    ENV["REFINERY_GEM_VERSION"]
  else
    $1 if File.read("#{RAILS_ROOT}/config/environment.rb") =~ /^[^#]*REFINERY_GEM_VERSION\s*=\s*["']([!~<>=]*\s*[\d.]+)["']/
  end
  
  if version
    gem 'refinery', version
  else
    gem 'refinery'
  end
  
  require 'refinery_initializer'
end

REFINERY_ROOT = RAILS_ROOT unless defined? REFINERY_ROOT