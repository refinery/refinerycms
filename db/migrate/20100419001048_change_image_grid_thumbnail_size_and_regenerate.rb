class ChangeImageGridThumbnailSizeAndRegenerate < ActiveRecord::Migration
  def self.up
    ((((thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})).is_a?(Hash) ? thumbnails : (RefinerySetting[:image_thumbnails] = {}))) rescue {})
    thumbnails[:grid] = "c124x124"
    RefinerySetting[:image_thumbnails] = thumbnails
    system("rake images:regenerate RAILS_ENV=#{Rails.env}")
  end

  def self.down
    ((((thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})).is_a?(Hash) ? thumbnails : (RefinerySetting[:image_thumbnails] = {}))) rescue {})
    thumbnails[:grid] = "c135x135"
    RefinerySetting[:image_thumbnails] = thumbnails
    system("rake images:regenerate RAILS_ENV=#{Rails.env}")
  end
end
