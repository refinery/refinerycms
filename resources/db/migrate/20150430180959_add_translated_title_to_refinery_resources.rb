class AddTranslatedTitleToRefineryResources < ActiveRecord::Migration[4.2]
  def change
    create_table :refinery_resource_translations do |t|

      # Translated attribute(s)
      t.string :resource_title

      t.string  :locale, null: false
      t.integer :refinery_resource_id, null: false

      t.timestamps null: false
    end

    add_index :refinery_resource_translations, :locale, name: :index_refinery_resource_translations_on_locale
    add_index :refinery_resource_translations, [:refinery_resource_id, :locale], name: :index_35a57b749803d8437ea64c64da3fb2cb0fbf457a, unique: true
  end
end