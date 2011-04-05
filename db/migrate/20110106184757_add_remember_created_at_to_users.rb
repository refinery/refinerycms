class AddRememberCreatedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_created_at, :datetime

    ::User.reset_column_information
  end

  def self.down
    remove_column :users, :remember_created_at

    ::User.reset_column_information
  end
end
