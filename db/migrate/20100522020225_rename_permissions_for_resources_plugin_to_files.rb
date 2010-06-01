class RenamePermissionsForResourcesPluginToFiles < ActiveRecord::Migration

  def self.up
    UserPlugin.find_all_by_title("Resources").each do |up|
      up.update_attribute(:title, "Files")
    end
  end

  def self.down
    UserPlugin.find_by_title("Files").each do |up|
      up.update_attribute(:title, "Resources")
    end
  end

end
