class ChangeToDeviseUsersTable < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.database_authenticatable
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      t.timestamps
      t.string :login
    end
  end

  def self.down
  end
end
