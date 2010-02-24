class RemoveThemesTable < ActiveRecord::Migration
  def self.up
    drop_table :themes
  end

  def self.down
    create_table "themes", :force => true do |t|
      t.integer "size"
      t.string "content_type"
      t.string "filename"
      t.string "title"
      t.text "description"
      t.text "license"
      t.timestamps
    end
  end
end
