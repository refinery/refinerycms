ApplicationController.class_eval do
  include Refinery::Pages::InstanceMethods
  helper Refinery::Pages::ContentPagesHelper
end
