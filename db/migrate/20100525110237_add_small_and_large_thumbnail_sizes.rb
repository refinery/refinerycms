class AddSmallAndLargeThumbnailSizes < ActiveRecord::Migration
  def self.up
    image_thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})
    RefinerySetting.image_thumbnails = image_thumbnails.merge({
      :small => '110x110>',
      :medium => '225x255>',
      :large => '450x450>'
    })
  end

  def self.down
    # don't really need to reverse it, it's not destructive if you run it multiple times.
  end
end
