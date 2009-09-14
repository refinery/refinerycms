class ChangeDefaultImageThumbnails < ActiveRecord::Migration
  def self.up
		RefinerySetting[:image_thumbnails] = "{
	:lightbox => '500x500>',
	:dialog_thumb => 'c106x106',
	:thumb => '50x50',
	:medium => '225x255',
	:side_body => '300x500',
	:preview => 'c96x96',
	:grid => 'c135x135'
}"
  end

  def self.down
		RefinerySetting[:image_thumbnails] = "{
	:lightbox => '500x500>',
	:dialog_thumb => 'c106x106',
	:thumb => '50x50',
	:medium => '225x255',
	:side_body => '300x500',
	:preview => 'c96x96'
}"
  end
end
