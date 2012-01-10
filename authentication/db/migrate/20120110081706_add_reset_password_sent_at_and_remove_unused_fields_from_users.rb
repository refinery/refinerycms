class AddResetPasswordSentAtAndRemoveUnusedFieldsFromUsers < ActiveRecord::Migration
  def change
    add_column Refinery::User.table_name, :reset_password_sent_at, :datetime

    remove_column Refinery::User.table_name, :remember_token
    remove_column Refinery::User.table_name, :perishable_token
    remove_column Refinery::User.table_name, :persistence_token
  end
end
