class RemoveBlurbFromNewsItems < ActiveRecord::Migration
  def self.up
    remove_column :news_items, :blurb
  end

  def self.down
    add_column :news_items, :blurb, :text
  end
end
