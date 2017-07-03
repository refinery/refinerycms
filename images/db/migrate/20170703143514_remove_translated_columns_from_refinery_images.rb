class RemoveTranslatedColumnsFromRefineryImages < ActiveRecord::Migration[5.0]
  def change
    remove_column :refinery_images, :image_title
    remove_column :refinery_images, :image_alt
  end
end
