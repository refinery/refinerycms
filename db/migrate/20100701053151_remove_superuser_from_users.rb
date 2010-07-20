class RemoveSuperuserFromUsers < ActiveRecord::Migration
  def self.up
    superusers = User.find_all_by_superuser(true)
    superusers.each do |user|
      user.add_role(:superuser)
      user.save(false)
    end

    remove_column :users, :superuser
  end

  def self.down
    add_column :users, :superuser, :boolean, :default => false

    User.reset_column_information
    Role[:superuser].users.each do |user|
      user.update_attribute(:superuser, true)
    end
  end
end
