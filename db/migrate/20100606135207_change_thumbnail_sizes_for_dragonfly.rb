class ChangeThumbnailSizesForDragonfly < ActiveRecord::Migration
  def self.up
    image_thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})
    image_thumbnails = image_thumbnails.update({
      :dialog_thumb => '106x106#c',
      :grid         => '135x135#c',
      :preview      => '96x96#c'
    })
    RefinerySetting[:image_thumbnails] = image_thumbnails
  end

  def self.down
    image_thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})
    image_thumbnails = image_thumbnails.update({
      :dialog_thumb => 'c106x106',
      :grid         => 'c135x135',
      :preview      => 'c96x96'
    })
    RefinerySetting[:image_thumbnails] = image_thumbnails
  end
end
