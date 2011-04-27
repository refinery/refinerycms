::Refinery::Application.routes.draw do
  match '/refinery/*path' => 'admin/base#error_404'
end
