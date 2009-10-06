# Get library path without '..' directories.
dir_parts = (File.join File.dirname(__FILE__), '..').split(File::SEPARATOR)
dir_parts = dir_parts[0..(dir_parts.length-3)] until dir_parts[dir_parts.length-1] != ".."
REFINERY_ROOT = File.join dir_parts

unless REFINERY_ROOT == RAILS_ROOT # e.g. only if we're in a gem.
  $LOAD_PATH.unshift "#{REFINERY_ROOT}/vendor/plugins"
  $LOAD_PATH.unshift "#{REFINERY_ROOT}/vendor/plugins/refinery/lib"
  
  require 'refinery'
  require 'refinery/initializer'
end