class CreateRefinerycmsAuthenticationSchema < ActiveRecord::Migration
  def self.up
    # Postgres apparently requires the roles_users table to exist before creating the roles table.
    create_table ::Refinery::RolesUsers.table_name, :id => false, :force => true do |t|
      t.integer "user_id"
      t.integer "role_id"
    end unless ::Refinery::RolesUsers.table_exists?

    create_table ::Refinery::Role.table_name, :force => true do |t|
      t.string "title"
    end unless ::Refinery::Role.table_exists?

    unless ::Refinery::UserPlugin.table_exists?
      create_table ::Refinery::UserPlugin.table_name, :force => true do |t|
        t.integer "user_id"
        t.string  "name"
        t.integer "position"
      end

      add_index ::Refinery::UserPlugin.table_name, ["name"], :name => "index_#{::Refinery::UserPlugin.table_name}_on_title"
      add_index ::Refinery::UserPlugin.table_name, ["user_id", "name"], :name => "index_unique_#{::Refinery::UserPlugin.table_name}", :unique => true

    end

    unless ::Refinery::User.table_exists?
      create_table ::Refinery::User.table_name, :force => true do |t|
        t.string   "login",             :null => false
        t.string   "email",             :null => false
        t.string   "crypted_password",  :null => false
        t.string   "password_salt",     :null => false
        t.string   "persistence_token"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "perishable_token"
      end

      add_index ::Refinery::User.table_name, ["id"], :name => "index_#{::Refinery::User.table_name}_on_id"
    end
  end

  def self.down
    [::User].reject{|m|
      !(defined?(m) and m.respond_to?(:table_name))
    }.each do |model|
      drop_table model.table_name if model.table_exists? if model.table_exists?
    end
  end
end
