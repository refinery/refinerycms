class RemovePasswordSaltFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :password_salt
    # Make the current password invalid :(
    ::User.all.each do |u|
      u.update_attribute(:encrypted_password, u.encrypted_password[29..-1])
    end

    ::User.reset_column_information
  end

  def self.down
    add_column :users, :password_salt, :string

    ::User.reset_column_information
  end
end
