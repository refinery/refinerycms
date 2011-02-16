class CreateRefinerycmsPagesSchema < ActiveRecord::Migration
  def self.up
    create_table ::PagePart.table_name, :force => true do |t|
      t.integer  "page_id"
      t.string   "title"
      t.text     "body"
      t.integer  "position"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index ::PagePart.table_name, ["id"], :name => "index_#{::PagePart.table_name}_on_id"
    add_index ::PagePart.table_name, ["page_id"], :name => "index_#{::PagePart.table_name}_on_page_id"

    create_table ::Page.table_name, :force => true do |t|
      t.string   "title"
      t.integer  "parent_id"
      t.integer  "position"
      t.string   "path"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "meta_keywords"
      t.text     "meta_description"
      t.boolean  "show_in_menu",        :default => true
      t.string   "link_url"
      t.string   "menu_match"
      t.boolean  "deletable",           :default => true
      t.string   "custom_title"
      t.string   "custom_title_type",   :default => "none"
      t.boolean  "draft",               :default => false
      t.string   "browser_title"
      t.boolean  "skip_to_first_child", :default => false
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "depth"
    end

    add_index ::Page.table_name, ["depth"], :name => "index_#{::Page.table_name}_on_depth"
    add_index ::Page.table_name, ["id"], :name => "index_#{::Page.table_name}_on_id"
    add_index ::Page.table_name, ["lft"], :name => "index_#{::Page.table_name}_on_lft"
    add_index ::Page.table_name, ["parent_id"], :name => "index_#{::Page.table_name}_on_parent_id"
    add_index ::Page.table_name, ["rgt"], :name => "index_#{::Page.table_name}_on_rgt"
  end

  def self.down
    [::Page, ::PagePart].reject{|m|
      !(defined?(m) and m.respond_to?(:table_name))
    }.each do |model|
      drop_table model.table_name
    end
  end
end
