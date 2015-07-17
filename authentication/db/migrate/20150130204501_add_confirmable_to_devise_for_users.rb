# This migration comes from refinery_glass (originally 20150130204501)
class AddConfirmableToDeviseForUsers < ActiveRecord::Migration
  def up
    change_table(:refinery_users) do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
    end
    add_index  :refinery_users, :confirmation_token, :unique => true

    Refinery::User.all do |user|
      if !user.confirmation_token.present? && !user.confirmed_at.present?
        user.confirmed_at = Time.new
        user.save
      end
    end
  end

  def down
    #remove_index(:refinery_users, column: :confirmation_token)
    remove_column :refinery_users, :confirmation_token
    remove_column :refinery_users, :confirmed_at
    remove_column :refinery_users, :confirmation_sent_at
    remove_column :refinery_users, :unconfirmed_email
  end
end
