class AddTitleAndDescriptionToImages < ActiveRecord::Migration
  def self.up
    add_column ::Image.table_name, :title, :string
    add_column ::Image.table_name, :description, :text
  end

  def self.down
    remove_column ::Image.table_name, :title
    remove_column ::Image.table_name, :description
  end
end