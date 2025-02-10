module Refinery
  module Admin
    module ImagesHelper
      def other_index_views
        Refinery::Images.index_views.reject do |view|
          view.to_s == Refinery::Images.preferred_index_view.to_s
        end
      end

      def thumbnail_urls(image)
        thumbnails = {
          original: image_path(image.url),
          grid: image_path(image.thumbnail(geometry: Refinery::Images.admin_image_sizes[:thumbnail]).url)
        }

        Refinery::Images.user_image_sizes.sort_by { |key, geometry| geometry }.each do |size, pixels|
          thumbnails[size.to_s.parameterize] = image_path(image.thumbnail(geometry: pixels).url)
        end
        { data: thumbnails }
      end

      def localized(date)
        ::I18n.l(Date.parse(date))
      end
    end
  end
end
