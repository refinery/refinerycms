::Rails.application.routes.draw do
  match '/refinery/*path' => 'admin/base#error_404'
end
