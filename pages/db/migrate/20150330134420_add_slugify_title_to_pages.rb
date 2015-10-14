class AddSlugifyTitleToPages < ActiveRecord::Migration
  def change
    add_column :refinery_pages, :slugify_title, :boolean, :default => true
  end
end
