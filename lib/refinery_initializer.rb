REFINERY_ROOT = File.join File.dirname(__FILE__), '..'

unless REFINERY_ROOT == RAILS_ROOT # e.g. only if we're in a gem.
  $LOAD_PATH.unshift "#{REFINERY_ROOT}/vendor/plugins"
  $LOAD_PATH.unshift "#{REFINERY_ROOT}/vendor/plugins/refinery/lib"
  
  require 'refinery'
  require 'refinery/initializer'
end