class CreateAddTemplateColumns < ActiveRecord::Migration
  def self.up
    add_column ::Refinery::Page.table_name, :view_template, :string
    add_column ::Refinery::Page.table_name, :layout_template, :string
  end

  def self.down
    remove_column ::Refinery::Page.table_name, :layout_template
    remove_column ::Refinery::Page.table_name, :view_template
  end
end
