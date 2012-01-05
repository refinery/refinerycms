Refinery::Core::Engine.routes.draw do
  namespace :admin, :path => 'refinery' do
    resources :settings, :except => :show
  end
end
