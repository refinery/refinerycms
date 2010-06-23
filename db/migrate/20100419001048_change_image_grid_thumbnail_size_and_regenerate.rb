class ChangeImageGridThumbnailSizeAndRegenerate < ActiveRecord::Migration
  def self.up
    image_thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})
    RefinerySetting.image_thumbnails = image_thumbnails.merge({:grid => "c124x124"})
    system("rake images:regenerate RAILS_ENV=#{Rails.env}")
  end

  def self.down
    image_thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})
    RefinerySetting.image_thumbnails = image_thumbnails.merge({:grid => "c135x135"})
    system("rake images:regenerate RAILS_ENV=#{Rails.env}")
  end
end
