Refinery::Application.routes.draw do
  match '*path' => 'pages#show'
end
