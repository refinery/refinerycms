class RemovePasswordSaltFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :password_salt
  end

  def self.down
    add_column :users, :password_salt, :string
  end
end
