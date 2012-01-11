Rails.application.routes.draw do
  scope(:as => 'refinery', :module => 'refinery') do
    scope(:module => '<%= plural_name %>', :as => '<%= plural_name %>') do
      resources :<%= class_name.pluralize.underscore.downcase %>, :only => [:index, :show]

      scope(:module => 'admin', :path => 'refinery/<%= plural_name %>', :as => 'admin') do
        resources :<%= class_name.pluralize.underscore.downcase %>, :path => '', :except => :show do
          collection do
            post :update_positions
          end
        end
      end
    end
  end
end
