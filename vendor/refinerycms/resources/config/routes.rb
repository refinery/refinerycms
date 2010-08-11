Refinery::Application.routes.draw do

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :resources do
      collection do
        get :insert
      end
    end
  end

end
