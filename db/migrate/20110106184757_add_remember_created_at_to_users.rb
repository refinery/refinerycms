class AddRememberCreatedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_created_at, :datetime

    ::Refinery::User.reset_column_information
  end

  def self.down
    remove_column :users, :remember_created_at

    ::Refinery::User.reset_column_information
  end
end
