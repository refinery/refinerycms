Refinery::Core::Engine.routes.draw do
  namespace :api do
    post '/graphql', to: 'graphql#execute'

    if Rails.env.development?
      mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: "/#{Refinery::Core.backend_route}/graphql"
    end
  end
end
