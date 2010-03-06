Rails::Application.routes.draw do
  resources :<%= class_name.pluralize.underscore.downcase %>

  namespace(:admin) do
    resources :<%= class_name.pluralize.underscore.downcase %>
  end
end
