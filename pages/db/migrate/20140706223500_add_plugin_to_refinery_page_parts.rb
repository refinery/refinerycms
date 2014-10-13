class AddPluginToRefineryPageParts < ActiveRecord::Migration
  def change
    change_table :refinery_page_parts do |t|
      t.string :plugin
    end

  end
end