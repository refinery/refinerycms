# make all attributes protected by default
#
# to open up certain attributes in you model use:
# attr_accessible :your_attribute
#
# if you prefer the opposite behaviour (all attributes open, just certain
# attributes locked down) just call attr_protected in your model:
#
# attr_protected :single_protected_attribute
#
# To open up all attributes can be dangerous. One example is an update of a
# foreign key attribute on a record which could lead to injection of records
# into another users objects.
class ActiveRecord::Base
  attr_accessible
end
