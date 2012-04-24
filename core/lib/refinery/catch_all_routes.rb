Refinery::Core::Engine.routes.append do
  get '/refinery/*path' => 'admin/base#error_404'
end
