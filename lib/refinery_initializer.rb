require 'pathname'
begin
  require 'vendor/plugins/refinery/lib/refinery'
rescue LoadError => load_error
  # We won't be able to load this if we're in the gem as there is no such thing.
end

refinery_root = Pathname.new((defined?(Refinery.root) ? Refinery.root.to_s : File.expand_path(File.dirname(__FILE__) << "/.."))) 
unless refinery_root == (defined?(Rails.root) ? Rails.root : Pathname.new(RAILS_ROOT)) # e.g. only if we're in a gem.
  $LOAD_PATH.unshift refinery_root.join("vendor", "plugins").to_s
  $LOAD_PATH.unshift refinery_root.join("vendor", "plugins", "refinery", "lib").to_s

  require 'refinery'
  Refinery.root = refinery_root
  require 'refinery/initializer'
end

# Pull in attachment_fu patch for windows
require 'refinery/attachment_fu_patch' if RUBY_PLATFORM =~ /mswin/