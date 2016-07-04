class AddSiteIdToPages < ActiveRecord::Migration
  def change
    add_column :refinery_pages, :site_id, :integer
    add_index  :refinery_pages, :site_id
  end
end
