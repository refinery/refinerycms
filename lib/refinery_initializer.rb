require 'pathname'
root_directory = Pathname.new(File.expand_path(File.dirname(__FILE__) << "/.."))
rails_root = ((defined?(Rails.root) && Rails.root.realpath.to_s.length > 0) ? Rails.root : Pathname.new(Rails.root))

if (non_gem_refinery = rails_root.join("vendor", "plugins", "refinery", "lib", "refinery.rb")).exist?
  require non_gem_refinery.realpath.to_s # this won't exist when using a gem.
else
  require root_directory.join("vendor", "plugins", "refinery", "lib", "refinery.rb").realpath.to_s
end

# Now we need to set some things that are used by the rest of the application.
Refinery.root = root_directory.cleanpath
if (Refinery.is_a_gem = (Refinery.root.realpath != rails_root.realpath))
  # If Refinery is installed from a gem then we need to load in a few extra files.
  $LOAD_PATH.unshift Refinery.root.join("vendor", "plugins").to_s
  $LOAD_PATH.unshift Refinery.root.join("vendor", "plugins", "refinery", "lib").to_s

  # We also need the refinery initializer when using a gem because this won't be autoloaded.
  require 'refinery/initializer'
end

# Pull in attachment_fu patch for windows
require 'refinery/attachment_fu_patch' if RUBY_PLATFORM =~ /mswin/
