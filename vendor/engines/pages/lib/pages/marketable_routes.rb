Rails::Application.routes.draw do
  match '*path' => 'pages#show'
end
