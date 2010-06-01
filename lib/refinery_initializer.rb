require 'pathname'

root_directory = Pathname.new(File.expand_path(File.dirname(__FILE__) << "/.."))
#rails_root = ((defined?(Rails.root) && Rails.root.realpath.to_s.length > 0) ? Rails.root : Pathname.new(Rails.root))

#if (non_gem_refinery = rails_root.join("vendor", "plugins", "refinery", "lib", "refinery.rb")).exist?
#  require non_gem_refinery.realpath.to_s # this won't exist when using a gem.
#  Refinery.is_a_gem = false
#else
#  require root_directory.join("vendor", "plugins", "refinery", "lib", "refinery").realpath.to_s
#  Refinery.is_a_gem = true
#end

module Refinery; end;

# Now we need to set some things that are used by the rest of the application.
Refinery.root = root_directory.cleanpath
$LOAD_PATH.unshift Refinery.root.join("vendor", "engines").to_s
$LOAD_PATH.unshift Refinery.root.join("vendor", "engines", "refinery", "lib").to_s
$LOAD_PATH.uniq!

Dir["#{Refinery.root.join("vendor", "engines").to_s}/*"].each do |d|
  $LOAD_PATH.unshift << "#{d}/lib"
end

# We also need the other refinery initializer.
# require 'refinery/initializer'
require 'authentication'
require 'dashboard'
require 'images'
require 'inquiries'
require 'pages'
require 'refinery_dialogs'
require 'refinery_settings'
require 'resources'
require 'themes'

# Pull in attachment_fu patch for windows
require 'refinery/attachment_fu_patch' if RUBY_PLATFORM =~ /mswin/
