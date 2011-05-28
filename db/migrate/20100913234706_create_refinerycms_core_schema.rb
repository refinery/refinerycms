class CreateRefinerycmsCoreSchema < ActiveRecord::Migration
  def self.up
    unless Slug.table_exists?
      create_table ::Slug.table_name, :force => true do |t|
        t.string   "name"
        t.integer  "sluggable_id"
        t.integer  "sequence",                     :default => 1, :null => false
        t.string   "sluggable_type", :limit => 40
        t.string   "scope",          :limit => 40
        t.datetime "created_at"
      end

      add_index ::Slug.table_name, ["name", "sluggable_type", "scope", "sequence"], :name => "index_#{::Slug.table_name}_on_n_s_s_and_s", :unique => true
      add_index ::Slug.table_name, ["sluggable_id"], :name => "index_#{::Slug.table_name}_on_sluggable_id"
    end
  end

  def self.down
    [::Slug].reject{|m|
      !(defined?(m) and m.respond_to?(:table_name))
    }.each do |model|
      drop_table model.table_name if model.table_exists?
    end
  end
end
