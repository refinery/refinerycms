Refinery::Core::Engine.routes.draw do
  namespace :api do
    post 'graphql' => 'graphql#execute'

    if Rails.env.development?
      mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    end
  end
end
