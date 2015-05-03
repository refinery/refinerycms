ApplicationController.class_eval do
  include Refinery::ApplicationController
  helper Refinery::Core::Engine.helpers
end
