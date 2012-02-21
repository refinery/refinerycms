class CreateRefinerycmsSettingsSchema < ActiveRecord::Migration
  def change
    create_table :refinery_settings do |t|
      t.string    :name
      t.text      :value
      t.boolean   :destroyable,             :default => true
      t.string    :scoping
      t.boolean   :restricted,              :default => false
      t.string    :callback_proc_as_string
      t.string    :form_value_type

      t.timestamps
    end

    add_index :refinery_settings, :name
  end
end
