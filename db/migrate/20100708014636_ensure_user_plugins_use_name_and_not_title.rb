class EnsureUserPluginsUseNameAndNotTitle < ActiveRecord::Migration
  def self.up
    rename_column :user_plugins, :title, :name if UserPlugin.table_exists? and UserPlugin.column_names.include?('title') and !UserPlugin.column_names.include?('name')
  end

  def self.down
    # We don't need to go backwards, there already is one that should handle that..
  end
end
