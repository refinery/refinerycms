class CreateSites < ActiveRecord::Migration
  def change
    create_table :refinery_sites do |t|
      t.string :name
      t.string :hostname

      t.timestamps
    end
  end
end
