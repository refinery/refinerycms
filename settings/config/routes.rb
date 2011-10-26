Rails.application.routes.draw do
  scope(:path => 'refinery', :as => 'refinery_admin', :module => 'refinery/admin') do
    resources :settings, :except => :show
  end
end
