require 'pathname'

require File.expand_path('../refinerycms', __FILE__)

# Override Refinery.root
# Must come after requiring 'refinerycms'
Refinery.root = File.expand_path('../../', __FILE__)
