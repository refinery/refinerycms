class CreateRefinerycmsCoreSchema < ActiveRecord::Migration
  def change
    create_table :slugs do |t|
      t.string    :name
      t.integer   :sluggable_id
      t.integer   :sequence,       :default => 1, :null => false
      t.string    :sluggable_type, :limit => 40
      t.string    :scope,          :limit => 40
      t.string    :locale

      t.timestamps
    end

    add_index :slugs, [:name, :sluggable_type, :scope, :sequence], :name => "index_slugs_on_n_s_s_and_s", :unique => true
    add_index :slugs, :sluggable_id
    add_index :slugs, :locale
  end
end
