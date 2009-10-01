REFINERY_ROOT = File.join File.dirname(__FILE__), '..'

unless REFINERY_ROOT == RAILS_ROOT # e.g. we're in a gem.
  $LOAD_PATH.unshift "#{REFINERY_ROOT}/vendor/plugins"
  $LOAD_PATH.unshift "#{REFINERY_ROOT}/vendor/plugins/refinery/lib"
  
  require 'refinery'
  require 'refinery/initializer'
  
  # it's important to include refinery first because it declares the refinery namespace.
#  module Refinery; end

  #Dir["#{REFINERY_ROOT}/vendor/plugins/**/*.rb"].sort.each { |lib| require lib }
end