Refinery::Core::Engine.routes.draw do
  
  match '/system/thumbs/:id(/:size)' => Dragonfly[:refinery_images].endpoint { |params, app|
    if params[:size].present? && Refinery::Images.user_image_sizes.keys.include?(params[:size])
      app.fetch(Refinery::Image.find(params[:id]).image_uid).thumb(params[:size])
    else
      app.fetch(Refinery::Image.find(params[:id]).image_uid)
    end
  }, :as => 'thumbnail'
  
  get '/system/images/*dragonfly', :to => Dragonfly[:refinery_images]

  namespace :admin, :path => 'refinery' do
    resources :images, :except => :show do
      get :insert, :on => :collection
    end
  end
end
