ActionController::Routing::Routes.draw do |map|
  map.resources :<%= class_name.pluralize.underscore.downcase %>

  map.with_options(:path_prefix => "refinery", :name_prefix => "admin_", :namespace => "admin/") do |admin|
    admin.resources :<%= class_name.pluralize.underscore.downcase %>
  end
end
