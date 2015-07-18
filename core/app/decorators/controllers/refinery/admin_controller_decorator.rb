Refinery::AdminController.class_eval do
  include Refinery::Pages::Admin::InstanceMethods
  helper Refinery::Pages::ContentPagesHelper
end
