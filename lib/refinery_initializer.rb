require 'pathname'
root_directory = File.expand_path(File.dirname(__FILE__) << "/..")
if File.exists?(File.join(root_directory, %w(vendor plugins refinery lib refinery)))
  require 'vendor/plugins/refinery/lib/refinery' # this won't exist when using a gem.
end

refinery_root = Pathname.new((defined?(Refinery.root) ? Refinery.root.to_s : root_directory))
unless refinery_root == (defined?(Rails.root) ? Rails.root : Pathname.new(RAILS_ROOT)) # e.g. only if we're in a gem.
  $LOAD_PATH.unshift refinery_root.join("vendor", "plugins").to_s
  $LOAD_PATH.unshift refinery_root.join("vendor", "plugins", "refinery", "lib").to_s

  require 'refinery'
  Refinery.root = refinery_root
  require 'refinery/initializer'
end

# Pull in attachment_fu patch for windows
require 'refinery/attachment_fu_patch' if RUBY_PLATFORM =~ /mswin/