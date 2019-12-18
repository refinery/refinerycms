Refinery::Core::Engine.routes.draw do
  namespace :api do
    post '/graphql', to: 'graphql#execute'
  end
end
