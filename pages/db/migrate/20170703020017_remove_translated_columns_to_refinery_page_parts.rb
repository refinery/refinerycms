class RemoveTranslatedColumnsToRefineryPageParts < ActiveRecord::Migration[5.0]
  def change
    remove_column :refinery_page_parts, :body
  end
end
