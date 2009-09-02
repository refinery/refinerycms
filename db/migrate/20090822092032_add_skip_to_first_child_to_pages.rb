class AddSkipToFirstChildToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :skip_to_first_child, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :skip_to_first_child
  end
end
