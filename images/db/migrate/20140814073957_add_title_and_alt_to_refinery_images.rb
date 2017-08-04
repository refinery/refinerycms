class AddTitleAndAltToRefineryImages < ActiveRecord::Migration[4.2]
  def change
    change_table :refinery_images do |t|
      t.string :image_title
      t.string :image_alt
    end
  end
end
