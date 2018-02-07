class AddCustomSlugToRefineryPages < ActiveRecord::Migration[4.2]
  def up
    add_column :refinery_pages, :custom_slug, :string unless custom_slug_exists?
  end

  def down
    remove_column :refinery_pages, :custom_slug if custom_slug_exists?
  end

  private

  def custom_slug_exists?
    column_exists?(:refinery_pages, :custom_slug)
  end
end
