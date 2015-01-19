class CreateRefinerycmsResourcesSchema < ActiveRecord::Migration
  def up
    unless table_exists? :refinery_resources
      create_table :refinery_resources do |t|
        t.string   :file_mime_type
        t.string   :file_name
        t.integer  :file_size
        t.string   :file_uid
        t.string   :file_ext

        t.timestamps
      end
    end
  end

  def down
    if table_exists? :refinery_resources
      drop_table :refinery_resources
    end
  end
end
