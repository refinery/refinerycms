class RemoveCustomTitleImageIdAndImageIdFromPages < ActiveRecord::Migration

  def self.up
    remove_column :pages, :custom_title_image_id
    remove_column :pages, :image_id
  end

  def self.down
    add_column :pages, :custom_title_image_id, :integer
    add_column :pages, :image_id, :integer
  end

end
