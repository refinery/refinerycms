module Refinery
  module Admin
    module ImagesHelper

      def image_views
        ::Refinery::Setting.find_or_set(:image_views, [:grid, :list])
      end

      def current_image_view
        ::Refinery::Setting.find_or_set(:preferred_image_view, :grid)
      end

      def other_image_views
        image_views.reject {|image_view| image_view.to_s == current_image_view.to_s }
      end

    end
  end
end
