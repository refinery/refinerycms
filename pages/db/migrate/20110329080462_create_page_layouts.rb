class CreatePageLayouts < ActiveRecord::Migration
  def self.up
    add_column :pages, :layout_template, :string
  end

  def self.down
    remove_column :pages, :layout
  end
end

