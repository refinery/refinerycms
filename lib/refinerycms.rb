unless defined?(REFINERYCMS_INSTALLER)
  require File.expand_path('../refinerycms/all', __FILE__)
else
  # If we're inside refinery use that one.
  if File.exist?(File.expand_path('../../base/lib/refinerycms-base.rb', __FILE__))
    require File.expand_path('../../base/lib/refinerycms-base.rb', __FILE__)
  else
    require 'refinerycms-base'
  end
end

# Override Refinery.root
# Must come after requiring 'refinerycms-base'
Refinery.root = Pathname.new(File.expand_path('../../', __FILE__))
