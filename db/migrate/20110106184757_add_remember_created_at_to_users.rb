class AddRememberCreatedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_created_at, :datetime
  end

  def self.down
    remove_column :users, :remember_created_at
  end
end
