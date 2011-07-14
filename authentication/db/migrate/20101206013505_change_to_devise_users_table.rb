class ChangeToDeviseUsersTable < ActiveRecord::Migration
  def self.up
    add_column ::Refinery::User.table_name, :current_sign_in_at, :datetime
    add_column ::Refinery::User.table_name, :last_sign_in_at, :datetime
    add_column ::Refinery::User.table_name, :current_sign_in_ip, :string
    add_column ::Refinery::User.table_name, :last_sign_in_ip, :string
    add_column ::Refinery::User.table_name, :sign_in_count, :integer
    add_column ::Refinery::User.table_name, :remember_token, :string
    add_column ::Refinery::User.table_name, :reset_password_token, :string

    rename_column ::Refinery::User.table_name, :crypted_password, :encrypted_password
    rename_column ::Refinery::User.table_name, :login, :username

    ::Refinery::User.reset_column_information
  end

  def self.down
    remove_column ::Refinery::User.table_name, :current_sign_in_at
    remove_column ::Refinery::User.table_name, :last_sign_in_at
    remove_column ::Refinery::User.table_name, :current_sign_in_ip
    remove_column ::Refinery::User.table_name, :last_sign_in_ip
    remove_column ::Refinery::User.table_name, :sign_in_count
    remove_column ::Refinery::User.table_name, :remember_token
    remove_column ::Refinery::User.table_name, :reset_password_token

    rename_column ::Refinery::User.table_name, :encrypted_password, :crypted_password
    rename_column ::Refinery::User.table_name, :username, :login

    ::Refinery::User.reset_column_information
  end
end
