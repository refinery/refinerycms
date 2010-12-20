class ChangeToDeviseUsersTable < ActiveRecord::Migration
  def self.up
    add_column ::User.table_name, :database_authenticatable, :boolean
    add_column ::User.table_name, :confirmable, :boolean
    add_column ::User.table_name, :recoverable, :boolean
    add_column ::User.table_name, :rememberable, :boolean
    add_column ::User.table_name, :trackable, :boolean

    rename_column ::User.table_name, :crypted_password, :encrypted_password
  end

  def self.down
    remove_column ::User.table_name, :database_authenticatable
    remove_column ::User.table_name, :confirmable
    remove_column ::User.table_name, :recoverable
    remove_column ::User.table_name, :rememberable
    remove_column ::User.table_name, :trackable

    rename_column ::User.table_name, :encrypted_password, :crypted_password
  end
end
