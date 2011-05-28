class AddRememberCreatedAtToUsers < ActiveRecord::Migration
  def change
    add_column ::Refinery::User.table_name, :remember_created_at, :datetime

    ::Refinery::User.reset_column_information
  end
end
