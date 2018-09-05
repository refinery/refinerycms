Refinery::Core::Engine.routes.draw do
  namespace :api do
    post '/graphql', to: 'graphql#execute'
  end

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/#{Refinery::Core.backend_route}/api/graphiql", graphql_path: '/api/graphql'
  end
end