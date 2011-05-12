unless defined?(REFINERYCMS_INSTALLER)
  require File.expand_path('../refinerycms/all', __FILE__)
else
  require 'refinerycms-base'
end

# Override Refinery.root
# Must come after requiring 'refinerycms-base'
Refinery.root = Pathname.new(File.expand_path('../../', __FILE__))
