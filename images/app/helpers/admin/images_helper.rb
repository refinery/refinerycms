module Admin::ImagesHelper

  def image_views
    RefinerySetting.find_or_set(:image_views, [:grid, :list])
  end

  def current_image_view
    RefinerySetting.find_or_set(:preferred_image_view, :list)
  end

  def other_image_views
    image_views.reject {|image_view| image_view.to_s == current_image_view.to_s }
  end

  def change_list_mode_if_specified
    if action_name == 'index' and params[:view].present? and image_views.include?(params[:view].to_sym)
      RefinerySetting[:preferred_image_view] = params[:view]
    end
  end

  def images_paginator(collection, dialog = false)
    will_paginate collection, :previous_label => '&laquo; Previous',
                              :next_label => 'Next &raquo;',
                              :renderer => Refinery::LinkRenderer
  end

end
