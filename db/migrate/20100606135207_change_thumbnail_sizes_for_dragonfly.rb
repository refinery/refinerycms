class ChangeThumbnailSizesForDragonfly < ActiveRecord::Migration
  def self.up
    RefinerySetting.set(:image_thumbnails, {
      :dialog_thumb => '106x106#c',
      :grid         => '135x135#c',
      :preview      => '96x96#c'
    })
  end

  def self.down
    RefinerySetting.set(:image_thumbnails, {
      :dialog_thumb => 'c106x106',
      :grid         => 'c135x135',
      :preview      => 'c96x96'
    })
  end
end
