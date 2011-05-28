::Refinery::Application.routes.draw do
  scope(:path => 'refinery', :as => 'refinery_admin', :module => 'refinery/admin') do
    resources :settings,
              :except => :show,
              :as => :settings,
              :controller => :settings
  end
end
