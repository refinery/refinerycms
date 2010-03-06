Rails::Application.routes.draw do
  namespace(:admin) do
    resources :dialogs # FIXME: Rails 3, :only => [:show]
  end
end
