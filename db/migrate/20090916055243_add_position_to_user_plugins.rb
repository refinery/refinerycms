class AddPositionToUserPlugins < ActiveRecord::Migration
  def self.up
    add_column :user_plugins, :position, :integer
  end

  def self.down
    remove_column :user_plugins, :position
  end
end
