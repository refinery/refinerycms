class CreateRefinerycmsResourcesManuals < ActiveRecord::Migration
  def up
    unless table_exists? :refinery_manuals
      create_table :refinery_manuals do |t|
        t.string :title
        t.binary :attachment, :limit => 15.megabyte
        t.string :mimetype
        t.string :filename
        t.timestamps
      end
    end
  end

  def down
    if table_exists? :refinery_manuals
      drop_table :refinery_manuals
    end
  end
end
