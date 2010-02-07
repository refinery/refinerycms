# pick the refinery root path
if File.exist?(File.join(%W(#{RAILS_ROOT} lib refinery_initializer.rb)))
  require File.join(%W(#{RAILS_ROOT} lib refinery_initializer.rb))
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
    gem 'refinerycms', version
  else
    gem 'refinerycms'
  end

  require 'refinery_initializer'
end


REFINERY_ROOT = Rails.root.to_s unless defined? REFINERY_ROOT

# Set to true in your environment specific file (e.g. production.rb) to use Amazon's Simple
# Storage Service instead of the default file system for resources and images
USE_S3_BACKEND = false unless defined?(USE_S3_BACKEND)