Refinery::Core::Engine.routes.draw do
  namespace :api do
    post '/api/graphql', to: 'graphql#execute'
  end
end
