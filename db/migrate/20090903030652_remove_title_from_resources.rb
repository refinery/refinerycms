class RemoveTitleFromResources < ActiveRecord::Migration
  def self.up
    remove_column :resources, :title
  end

  def self.down
    add_column :resources, :title, :string
  end
end
