class AddMissingIndexesToRolesUsers < ActiveRecord::Migration
  def self.up
    add_index ::RolesUsers.table_name, [:role_id, :user_id]
    add_index ::RolesUsers.table_name, [:user_id, :role_id]
  end

  def self.down
    remove_index ::RolesUsers.table_name, :column => [:role_id, :user_id]
    remove_index ::RolesUsers.table_name, :column => [:user_id, :role_id]
  end
end
