module Refinery
  module Helpers
    module PaginationHelper

      # Figures out the CSS classname to apply to your pagination list for animations.
      def pagination_css_class
        if request.xhr? and params[:from_page].present? and params[:page].present?
          "frame_#{params[:from_page].to_s > params[:page].to_s ? 'left' : 'right'}"
        else
          "frame_center"
        end
      end

    end
  end
end
