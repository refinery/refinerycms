class AddMissingIndexesToRolesUsers < ActiveRecord::Migration
  def self.up
    add_index :roles_users, [:role_id, :user_id]
    add_index :roles_users, [:user_id, :role_id]
  end

  def self.down
    remove_index :roles_users, :column => [:role_id, :user_id]
    remove_index :roles_users, :column => [:user_id, :role_id]
  end
end
