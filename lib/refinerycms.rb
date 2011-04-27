require 'refinerycms-base'

require File.expand_path('../refinerycms/all', __FILE__) unless defined?(REFINERYCMS_INSTALLER)

# Override Refinery.root
# Must come after requiring 'refinerycms-base'
Refinery.root = Pathname.new(File.expand_path('../../', __FILE__))
