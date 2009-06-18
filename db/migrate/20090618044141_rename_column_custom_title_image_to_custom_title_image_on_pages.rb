class RenameColumnCustomTitleImageToCustomTitleImageOnPages < ActiveRecord::Migration
  def self.up
    rename_column :pages, :custom_title_image, :custom_title_image_id
  end

  def self.down
    rename_column :pages, :custom_title_image_id, :custom_title_image
  end
end
