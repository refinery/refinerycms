Rails.application.routes.draw do
  scope(:as => 'refinery', :module => 'refinery') do
    scope(:module => '<%= namespacing.underscore %>', :as => '<%= namespacing.underscore.pluralize %>') do
      resources :<%= class_name.pluralize.underscore.downcase %>, :only => [:index, :show]

      scope(:module => 'admin', :path => 'refinery/<%= namespacing.underscore.pluralize %>', :as => 'admin') do
        resources :<%= class_name.pluralize.underscore.downcase %>, :path => '', :except => :show do
          collection do
            post :update_positions
          end
        end
      end
    end
  end
end
