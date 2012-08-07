class CreateRefinerycmsThumbsSchema < ActiveRecord::Migration
  def change
    create_table :refinery_thumbs do |t|
      t.string   :uid
      t.string   :job
      t.timestamps
    end
  end
end