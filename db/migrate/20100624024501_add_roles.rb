class AddRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :title
    end

    create_table :roles_users, :id => false do |t|
      t.integer :user_id
      t.integer :role_id
    end

    # All users at this point will be Refinery admin users, so add the Refinery role to
    # each of them.
    refinery = Role.find_or_create_by_title('Refinery')
    User.all.each do |user|
      user.roles << refinery
      user.save!
    end
  end

  def self.down
    drop_table :roles
    drop_table :roles_users
  end
end
