class AddAltTextToImages < ActiveRecord::Migration
  def change
    add_column ::Refinery::Image.table_name, :alt, :text
  end
end
