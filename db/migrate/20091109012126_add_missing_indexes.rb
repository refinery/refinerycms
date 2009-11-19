class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :pages, :parent_id
    add_index :pages, :custom_title_image_id
    add_index :pages, :image_id
    add_index :images, :parent_id
    add_index :page_parts, :page_id

    add_index :pages, :id
    add_index :page_parts, :id
    add_index :users, :id
  end

  def self.down
    remove_index :pages, :parent_id
    remove_index :pages, :custom_title_image_id
    remove_index :pages, :image_id
    remove_index :images, :parent_id
    remove_index :page_parts, :page_id

    remove_index :pages, :id
    remove_index :page_parts, :id
    remove_index :users, :id
  end
end
