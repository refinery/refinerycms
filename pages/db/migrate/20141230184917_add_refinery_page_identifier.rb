class AddRefineryPageIdentifier < ActiveRecord::Migration
  def change
    add_column :refinery_pages, :identifier, :string
  end
end
