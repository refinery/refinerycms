ActionController::Routing::Routes.draw do |map|
  map.resources :<%= class_name.pluralize.underscore.downcase %>

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :<%= class_name.pluralize.underscore.downcase %>, :collection => {:update_positions => :post}
  end
end
