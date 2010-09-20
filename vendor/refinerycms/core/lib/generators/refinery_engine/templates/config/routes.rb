Refinery::Application.routes.draw do
  resources :<%= class_name.pluralize.underscore.downcase %>

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :<%= class_name.pluralize.underscore.downcase %> do
      collection do
        post :update_positions
      end
    end
  end
end
