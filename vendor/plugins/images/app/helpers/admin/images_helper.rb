module Admin::ImagesHelper
  
  def image_views
    ["grid", "list"]
  end
  
  def current_image_view
    session[:image_view] || :list
  end
  
  def alternate_image_view
    image_views.reject {|i| i == current_image_view.to_s }[0]
  end
  
  def change_list_mode_if_specified
    if params[:action] == "index" and not params[:view].blank?
      session[:image_view] = params[:view] if ["grid", "list"].include?(params[:view])
    end
  end
  
end