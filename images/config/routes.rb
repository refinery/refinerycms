Refinery::Core::Engine.routes.draw do
  match '/system/thumbs/:id(/:style)' => Dragonfly[:refinery_images].endpoint { |params, app|
    if params[:style]
      app.fetch(Refinery::Image.find(params[:id]).image_uid).thumb(params[:style])
    else
      app.fetch(Refinery::Image.find(params[:id]).image_uid)
    end
  }, :as => "thumbnail"
  
  get '/system/images/*dragonfly', :to => Dragonfly[:refinery_images]

  namespace :admin, :path => 'refinery' do
    resources :images, :except => :show do
      get :insert, :on => :collection
    end
  end
end
