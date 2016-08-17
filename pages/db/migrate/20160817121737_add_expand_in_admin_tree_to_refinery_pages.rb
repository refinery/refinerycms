class AddExpandInAdminTreeToRefineryPages < ActiveRecord::Migration
  def change
    add_column :refinery_pages, :expand_in_admin_tree, :boolean, default: true
  end
end
