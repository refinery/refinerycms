class CreateRefinerySchema < ActiveRecord::Migration
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

    create_table ::Inquiry.table_name, :force => true do |t|
      t.string   "name"
      t.string   "email"
      t.string   "phone"
      t.text     "message"
      t.integer  "position"
      t.boolean  "open",       :default => true
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "spam",       :default => false
    end

    create_table ::InquirySetting.table_name, :force => true do |t|
      t.string   "name"
      t.text     "value"
      t.boolean  "destroyable"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

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
      t.string   "cached_slug"
    end

    add_index ::Page.table_name, ["depth"], :name => "index_#{::Page.table_name}_on_depth"
    add_index ::Page.table_name, ["id"], :name => "index_#{::Page.table_name}_on_id"
    add_index ::Page.table_name, ["lft"], :name => "index_#{::Page.table_name}_on_lft"
    add_index ::Page.table_name, ["parent_id"], :name => "index_#{::Page.table_name}_on_parent_id"
    add_index ::Page.table_name, ["rgt"], :name => "index_#{::Page.table_name}_on_rgt"

    create_table ::RefinerySetting.table_name, :force => true do |t|
      t.string   "name"
      t.text     "value"
      t.boolean  "destroyable",             :default => true
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "scoping"
      t.boolean  "restricted",              :default => false
      t.string   "callback_proc_as_string"
    end

    add_index ::RefinerySetting.table_name, ["name"], :name => "index_#{::RefinerySetting.table_name}_on_name"

    create_table ::Resource.table_name, :force => true do |t|
      t.string   "file_mime_type"
      t.string   "file_name"
      t.integer  "file_size"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "file_uid"
      t.string   "file_ext"
    end

    # Postgres apparently requires the roles_users table to exist before creating the roles table.
    create_table ::RolesUsers.table_name, :id => false, :force => true do |t|
      t.integer "user_id"
      t.integer "role_id"
    end

    create_table ::Role.table_name, :force => true do |t|
      t.string "title"
    end

    create_table ::Slug.table_name, :force => true do |t|
      t.string   "name"
      t.integer  "sluggable_id"
      t.integer  "sequence",                     :default => 1, :null => false
      t.string   "sluggable_type", :limit => 40
      t.string   "scope",          :limit => 40
      t.datetime "created_at"
    end

    add_index ::Slug.table_name, ["name", "sluggable_type", "scope", "sequence"], :name => "index_#{::Slug.table_name}_on_name_and_sluggable_type_and_scope_and_sequence", :unique => true
    add_index ::Slug.table_name, ["sluggable_id"], :name => "index_#{::Slug.table_name}_on_sluggable_id"

    create_table ::UserPlugin.table_name, :force => true do |t|
      t.integer "user_id"
      t.string  "name"
      t.integer "position"
    end

    add_index ::UserPlugin.table_name, ["name"], :name => "index_#{::UserPlugin.table_name}_on_title"
    add_index ::UserPlugin.table_name, ["user_id", "name"], :name => "index_unique_#{::UserPlugin.table_name}", :unique => true

    create_table ::User.table_name, :force => true do |t|
      t.string   "login",             :null => false
      t.string   "email",             :null => false
      t.string   "crypted_password",  :null => false
      t.string   "password_salt",     :null => false
      t.string   "persistence_token"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "perishable_token"
    end

    add_index ::User.table_name, ["id"], :name => "index_#{::User.table_name}_on_id"
  end

  def self.down
    [::Image, ::Page, ::PagePart, ::RefinerySetting, ::Slug, ::User].reject{|m|
      !(defined?(m) and m.respond_to?(:table_name))
    }.each do |model|
      drop_table model.table_name
    end
  end
end
