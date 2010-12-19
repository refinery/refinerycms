class CreateRefinerycmsImagesSchema < ActiveRecord::Migration
  def self.up
    create_table ::Image.table_name, :force => true do |t|
      t.string   "image_mime_type"
      t.string   "image_name"
      t.integer  "image_size"
      t.integer  "image_width"
      t.integer  "image_height"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "image_uid"
      t.string   "image_ext"
    end
  end

  def self.down
    [::Image].reject{|m|
      !(defined?(m) and m.respond_to?(:table_name))
    }.each do |model|
      drop_table model.table_name
    end
  end
end
