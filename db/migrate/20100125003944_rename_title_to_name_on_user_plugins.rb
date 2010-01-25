class RenameTitleToNameOnUserPlugins < ActiveRecord::Migration
  def self.up
    rename_column :user_plugins, :title, :name
  end

  def self.down
    rename_column :user_plugins, :name, :title
  end
end
