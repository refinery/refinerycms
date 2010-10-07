class RemoveImageThumbnailsFromRefinerySettings < ActiveRecord::Migration
  def self.up
    image_thumbnails = RefinerySetting.get(:image_thumbnails)
    user_image_sizes =  RefinerySetting.find_or_set(:user_image_sizes, image_thumbnails || {
      :small => '110x110>',
      :medium => '225x255>',
      :large => '450x450>'
    })
    image_thumbnails_settings = RefinerySetting.find_by_name 'image_thumbnails'
    image_thumbnails_settings.destroy if image_thumbnails_settings
  end

  def self.down
    image_thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {
      :small => '110x110>',
      :medium => '225x255>',
      :large => '450x450>'
    })
    user_image_sizes_settings = RefinerySetting.find_by_name 'user_image_sizes'
    user_image_sizes_settings.destroy if user_image_sizes_settings
  end
end
