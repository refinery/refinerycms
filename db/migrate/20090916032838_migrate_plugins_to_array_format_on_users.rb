class MigratePluginsToArrayFormatOnUsers < ActiveRecord::Migration
  def self.up
		User.all.each do |user|
			user.update_attribute(:plugins, user.plugins)
		end
  end

  def self.down
		User.all.each do |user|
			user.update_attribute(:plugins, user.plugins)
		end
  end
end
