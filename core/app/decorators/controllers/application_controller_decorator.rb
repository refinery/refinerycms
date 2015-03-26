ApplicationController.class_eval do
  include Refinery::Pages::InstanceMethods
  helper Refinery::Pages::ContentPagesHelper

  include Refinery::ApplicationController
  helper Refinery::Core::Engine.helpers
end
