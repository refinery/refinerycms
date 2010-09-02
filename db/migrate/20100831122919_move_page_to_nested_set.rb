class MovePageToNestedSet < ActiveRecord::Migration
  def self.up
    # Add nested set columns
    add_column :pages, :lft, :integer
    add_column :pages, :rgt, :integer
    
    add_index :pages, :lft
    add_index :pages, :rgt

    # Rebuild the page table
    Page.rebuild!
  end

  def self.down
    remove_index :pages, :lft
    remove_index :pages, :rgt
    
    remove_column :pages, :lft
    remove_column :pages, :rgt
  end
end
