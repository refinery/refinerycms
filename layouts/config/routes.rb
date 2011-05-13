Refinery::Application.routes.draw do
  resources :layouts, :only => [:index, :show]

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :layouts, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
