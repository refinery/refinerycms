class RemoveStateFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :state
  end

  def self.down
    add_column :users, :state, :string
  end
end
