class MovePageToNestedSet < ActiveRecord::Migration
  def self.up
    # Add nested set columns
    add_column :pages, :lft, :integer
    add_column :pages, :rgt, :integer

    # Rebuild the page table
    Page.rebuild!
  end

  def self.down
    remove_column :pages, :lft
    remove_column :pages, :rgt
  end
end
