class AddSlugToRefineryPageParts < ActiveRecord::Migration
  def change
    rename_column :refinery_page_parts, :title, :slug
    add_column :refinery_page_parts, :title, :string
  end
end
