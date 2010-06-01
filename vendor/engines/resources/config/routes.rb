Rails::Application.routes.draw do

  resources :resources

  scope(:path => 'refinery', :name_prefix => 'admin', :module => 'admin') do
    resources :resources do
      collection do
        get :insert
      end
    end
  end

end
