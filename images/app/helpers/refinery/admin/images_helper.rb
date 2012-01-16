module Refinery
  module Admin
    module ImagesHelper
      def other_image_views
        Refinery::Images.image_views.reject { |image_view|
          image_view.to_s == Refinery::Images.preferred_image_view.to_s
        }
      end
    end
  end
end
