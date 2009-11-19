# This file is here to support web servers who load Rails in the old fashion e.g. some builds of Phusion Passenger.
# This will simply load the application controller using the new style if this file is ever loaded.
require_dependency 'application_controller'
