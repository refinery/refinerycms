begin
  require "rubygems"
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
  raise RuntimeError, "Your bundler version is too old." +
   "Run `gem install bundler` to upgrade."
end

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end

require 'pathname'
# pick the refinery root path
rails_root = (defined?(Rails.root) ? Rails.root : Pathname.new(RAILS_ROOT)).cleanpath
if (non_gem_path = rails_root.join("vendor", "plugins", "refinery", "lib", "refinery.rb")).exist?
  require non_gem_path.realpath.to_s
else
  version = if defined? REFINERY_GEM_VERSION
    REFINERY_GEM_VERSION
  elsif ENV.include?("REFINERY_GEM_VERSION")
    ENV["REFINERY_GEM_VERSION"]
  else
    $1 if rails_root.join("config", "application.rb").read =~ /^[^#]*REFINERY_GEM_VERSION\s*=\s*["']([!~<>=]*\s*[\d.]+)["']/
  end

  require "rubygems"
  if version
    gem 'refinerycms', version
  else
    gem 'refinerycms'
  end

  require 'refinery_initializer'
end
