class AddParentIdToRefineryImages < ActiveRecord::Migration[5.1]
  def change
    add_column :refinery_images, :parent_id, :integer
  end
end