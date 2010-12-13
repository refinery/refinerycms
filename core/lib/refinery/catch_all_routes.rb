::Refinery::Application.routes.draw do
  match '/admin(/*path)', :to => redirect {|params, request|
    request.flash[:message] = "<p>
      The URL '/<strong>admin</strong>#{"/#{params[:path]}" unless params[:path].blank?}' will be removed in Refinery CMS version 1.0
      <br/>
      Please use '/<strong>refinery</strong>#{"/#{params[:path]}" unless params[:path].blank?}' instead.
    </p>".html_safe
    "/refinery#{"/#{params[:path]}" unless params[:path].blank?}"
  }
  match '/refinery/*path' => 'admin/base#error_404'
end
