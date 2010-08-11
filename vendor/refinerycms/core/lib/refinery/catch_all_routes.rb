Refinery::Application.routes.draw do
  match '/admin' => redirect('/refinery')
  match '/admin(/*path)' => redirect('/refinery/%{path}')
  match '/refinery/*path' => 'admin/base#error_404'
end
