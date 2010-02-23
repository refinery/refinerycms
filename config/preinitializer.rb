require 'pathname'

# until Rails 3
# ENV["GEM_HOME"] = File.expand_path('../../vendor/bundler_gems', __FILE__)

# pick the refinery root path
rails_root = (defined?(Rails.root) ? Rails.root : Pathname.new(RAILS_ROOT)).cleanpath
if (non_gem_path = rails_root.join("lib", "refinery_initializer.rb")).exist?
  require non_gem_path.to_s
else
  require 'rubygems'
  version = if defined? REFINERY_GEM_VERSION
    REFINERY_GEM_VERSION
  elsif ENV.include?("REFINERY_GEM_VERSION")
    ENV["REFINERY_GEM_VERSION"]
  else
    $1 if rails_root.join("config", "application.rb").read =~ /^[^#]*REFINERY_GEM_VERSION\s*=\s*["']([!~<>=]*\s*[\d.]+)["']/
  end

  if version
    gem 'refinerycms', version
  else
    gem 'refinerycms'
  end

  require 'refinery_initializer'
end

# Set to true in your environment specific file (e.g. production.rb) to use Amazon's Simple
# Storage Service instead of the default file system for resources and images
USE_S3_BACKEND = false unless defined?(USE_S3_BACKEND)