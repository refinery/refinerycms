ActionController::Routing::Routes.draw do |map|
  map.resources :<%= class_name.pluralize.underscore.downcase %>

  map.namespace(:admin) do |admin|
    admin.resources :<%= class_name.pluralize.underscore.downcase %>
  end
end
