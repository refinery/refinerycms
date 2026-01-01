# frozen_string_literal: true

module Refinery
  module Admin
    module ImagesHelper
      def other_image_views
        Refinery::Images.image_views.reject do |image_view|
          image_view.to_s == Refinery::Images.preferred_image_view.to_s
        end
      end

      def locale_text_icon(text)
        text
      end

      def thumbnail_urls(image)
        thumbnails = {
          original: image_path(image.url),
          grid: image_path(image.thumbnail(geometry: '135x135#c').url)
        }

        Refinery::Images.user_image_sizes.sort_by { |key, geometry| geometry }.each do |size, pixels|
          thumbnails[size.to_s.parameterize] = image_path(image.thumbnail(geometry: pixels).url)
        end

        { data: thumbnails }
      end
    end
  end
end
