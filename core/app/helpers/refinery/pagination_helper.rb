module Refinery
  module PaginationHelper

    # Figures out the CSS classname to apply to your pagination list for animations.
    def pagination_css_class
      if request.xhr? and params[:from_page].present?
        "frame_#{params[:from_page] > (params[:page] ? params[:page] : "1") ? 'left' : 'right'}"
      else
        "frame_center"
      end
    end

  end
end
