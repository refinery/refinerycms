module Refinery
  module Admin
    module ImagesHelper
      def other_image_views
        Refinery::Images.image_views.reject { |image_view|
          image_view.to_s == Refinery::Images.preferred_image_view.to_s
        }
      end

      def thumbnail_urls(image)
        thumbnail_urls = {
          :"data-original" => asset_paths.compute_public_path(image.url, ''),
          :"data-grid" => asset_paths.compute_public_path(image.thumbnail('135x135#c').url, '')
        }

        Refinery::Images.user_image_sizes.sort_by{|key,geometry| geometry}.each do |size, pixels|
          thumbnail_urls[:"data-#{size.to_s.parameterize}"] = asset_paths.compute_public_path(image.thumbnail(pixels).url, '')
        end

        thumbnail_urls
      end
    end
  end
end
