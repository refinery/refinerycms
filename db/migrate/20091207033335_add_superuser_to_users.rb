class AddSuperuserToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :superuser, :boolean, :default => false
    unless (user = User.first).nil?
      user.update_attribute(:superuser, true)
    end
  end

  def self.down
    remove_column :users, :superuser
  end
end
