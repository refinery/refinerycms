# Call attr_accessible for all Models in Testing.
# So all mass assignment access to Models in tests fails if attr_accessible
# is not correct set
class ActiveRecord::Base
  attr_accessible
end
