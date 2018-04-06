class TranslateRefineryImages < ActiveRecord::Migration[4.2]
  def change
    create_table :refinery_image_translations do |t|

      # Translated attribute(s)
      t.string :image_alt
      t.string :image_title

      t.string  :locale, null: false
      t.integer :refinery_image_id, null: false

      t.timestamps null: false
    end

    add_index :refinery_image_translations, :locale, name: :index_refinery_image_translations_on_locale
    add_index :refinery_image_translations, [:refinery_image_id, :locale], name: :index_2f245f0c60154d35c851e1df2ffc4c86571726f0, unique: true
  end
end