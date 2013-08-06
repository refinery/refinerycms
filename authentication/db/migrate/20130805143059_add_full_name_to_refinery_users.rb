class AddFullNameToRefineryUsers < ActiveRecord::Migration
  def change
    add_column :refinery_users, :full_name, :string
  end
end
