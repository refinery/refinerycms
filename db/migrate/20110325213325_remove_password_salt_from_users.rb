class RemovePasswordSaltFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :password_salt
    # Make the current password invalid :(
    ::Refinery::User.all.each do |u|
      u.update_attribute(:encrypted_password, u.encrypted_password[29..-1])
    end

    ::Refinery::User.reset_column_information
  end

  def self.down
    add_column :users, :password_salt, :string

    ::Refinery::User.reset_column_information
  end
end
