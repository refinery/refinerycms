begin
  require "rubygems"
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

unless Gem::Version.new(Bundler::VERSION) > Gem::Version.new("0.9.20")
  raise RuntimeError, "Your bundler version is too old. Run `gem install bundler` to upgrade."
end

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup

  if File.exist?(non_gem_refinery_file = File.expand_path("../../vendor/plugins/refinery/lib/refinery.rb", __FILE__))
    require non_gem_refinery_file.to_s
  else
    require 'refinery_initializer'
  end

rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems. Did you run `bundle install`?\nMessage was: #{$!.message}"
end
