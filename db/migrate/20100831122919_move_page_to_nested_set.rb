class MovePageToNestedSet < ActiveRecord::Migration
  def self.up
    # Add nested set columns
    add_column :pages, :lft, :integer
    add_column :pages, :rgt, :integer

    add_column :pages, :depth, :integer

    add_index :pages, :lft
    add_index :pages, :rgt
    add_index :pages, :depth

    # Rebuild the page table
    Page.rebuild!
  end

  def self.down
    remove_index :pages, :lft
    remove_index :pages, :rgt

    remove_index :pages, :depth

    remove_column :pages, :lft
    remove_column :pages, :rgt

    remove_column :pages, :depth
  end
end
