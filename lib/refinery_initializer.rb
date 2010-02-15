REFINERY_ROOT = File.expand_path(File.dirname(__FILE__) << "/..")

unless REFINERY_ROOT == RAILS_ROOT # e.g. only if we're in a gem.
  $LOAD_PATH.unshift "#{REFINERY_ROOT}/vendor/plugins"
  $LOAD_PATH.unshift "#{REFINERY_ROOT}/vendor/plugins/refinery/lib"

  require 'refinery'
  require 'refinery/initializer'
end

# Pull in attachment_fu patch for windows
require 'refinery/attachment_fu_patch' if RUBY_PLATFORM =~ /mswin/