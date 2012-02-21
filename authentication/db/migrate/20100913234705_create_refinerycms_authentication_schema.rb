class CreateRefinerycmsAuthenticationSchema < ActiveRecord::Migration
  def change
    # Postgres apparently requires the roles_users table to exist before creating the roles table.
    create_table :refinery_roles_users, :id => false do |t|
      t.integer :user_id
      t.integer :role_id
    end

    add_index :refinery_roles_users, [:role_id, :user_id]
    add_index :refinery_roles_users, [:user_id, :role_id]

    create_table :refinery_roles do |t|
      t.string :title
    end

    create_table :refinery_user_plugins do |t|
      t.integer :user_id
      t.string  :name
      t.integer :position
    end

    add_index :refinery_user_plugins, :name
    add_index :refinery_user_plugins, [:user_id, :name], :unique => true

    create_table :refinery_users do |t|
      t.string    :username,            :null => false
      t.string    :email,               :null => false
      t.string    :encrypted_password,  :null => false
      t.datetime  :current_sign_in_at
      t.datetime  :last_sign_in_at
      t.string    :current_sign_in_ip
      t.string    :last_sign_in_ip
      t.integer   :sign_in_count
      t.datetime  :remember_created_at
      t.string    :reset_password_token
      t.datetime  :reset_password_sent_at

      t.timestamps
    end

    add_index :refinery_users, :id
  end
end
