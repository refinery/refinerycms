Rails.application.routes.draw do
  scope(:as => 'refinery', :module => 'refinery') do
    resources :<%= class_name.pluralize.underscore.downcase %>, :only => [:index, :show]
  end
end

Refinery::Core::Engine.routes.append do
  scope(:path => 'refinery', :as => 'refinery_admin', :module => 'refinery/admin') do
    resources :<%= class_name.pluralize.underscore.downcase %>, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
