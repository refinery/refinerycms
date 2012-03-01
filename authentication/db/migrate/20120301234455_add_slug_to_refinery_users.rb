class AddSlugToRefineryUsers < ActiveRecord::Migration
  def change
    add_column :refinery_users, :slug, :string
    add_index :refinery_users, :slug

  end
end
