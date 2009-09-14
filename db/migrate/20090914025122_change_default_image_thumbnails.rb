class ChangeDefaultImageThumbnails < ActiveRecord::Migration
  def self.up
		RefinerySetting[:image_thumbnails] = RefinerySetting[:image_thumbnails].merge({:grid => 'c135x135'})
  end

  def self.down
		RefinerySetting[:image_thumbnails] = RefinerySetting[:image_thumbnails].delete_if {|key, value| key == :grid }
  end
end
