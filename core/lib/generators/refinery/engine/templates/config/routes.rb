Rails.application.routes.draw do
  scope(:as => 'refinery', :module => 'refinery') do
    scope(:module => '<%= namespacing.underscore %>', :as => '<%= namespacing.underscore %>') do
      resources :<%= class_name.pluralize.underscore.downcase %>, :only => [:index, :show]

      scope(:module => 'admin', :path => 'refinery/<%= namespacing.underscore %>', :as => 'admin') do
        resources :<%= class_name.pluralize.underscore.downcase %><%= ", :path => ''" if namespacing.underscore.pluralize == class_name.pluralize.underscore.downcase %>, :except => :show do
          collection do
            post :update_positions
          end
        end
      end
    end
  end
end
