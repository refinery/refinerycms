class CreateRefinerycmsImagesSchema < ActiveRecord::Migration[4.2]
  def change
    create_table :refinery_images do |t|
      t.string   :image_mime_type
      t.string   :image_name
      t.integer  :image_size
      t.integer  :image_width
      t.integer  :image_height
      t.string   :image_uid
      t.string   :image_ext

      t.timestamps
    end
  end
end
