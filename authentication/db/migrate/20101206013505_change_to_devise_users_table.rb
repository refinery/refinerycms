class ChangeToDeviseUsersTable < ActiveRecord::Migration
  def self.up
    add_column ::User.table_name, :current_sign_in_at, :datetime
    add_column ::User.table_name, :last_sign_in_at, :datetime
    add_column ::User.table_name, :current_sign_in_ip, :string
    add_column ::User.table_name, :last_sign_in_ip, :string
    add_column ::User.table_name, :sign_in_count, :integer
    add_column ::User.table_name, :remember_token, :string
    add_column ::User.table_name, :reset_password_token, :string

    rename_column ::User.table_name, :crypted_password, :encrypted_password
    rename_column ::User.table_name, :login, :username
  end

  def self.down
    remove_column ::User.table_name, :current_sign_in_at
    remove_column ::User.table_name, :last_sign_in_at
    remove_column ::User.table_name, :current_sign_in_ip
    remove_column ::User.table_name, :last_sign_in_ip
    remove_column ::User.table_name, :sign_in_count
    remove_column ::User.table_name, :remember_token
    remove_column ::User.table_name, :reset_password_token

    rename_column ::User.table_name, :encrypted_password, :crypted_password
    rename_column ::User.table_name, :username, :login
  end
end
