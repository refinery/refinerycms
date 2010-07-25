Rails::Application.routes.draw do

  scope(:path => 'refinery', :name_prefix => 'admin', :module => 'admin') do
    resources :resources do
      collection do
        get :insert
      end
    end
  end

end
