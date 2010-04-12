class ChangeUsersColumnsForAuthlogic < ActiveRecord::Migration
  def self.up
    # Change users table to use Authlogic-compatible schema
    change_table "users" do |t|
      User.all(:conditions => "`users`.reset_code IS NULL").each do |user|
        new_code = Authlogic::Random.friendly_token
        user.update_attribute(:reset_code, new_code)
      end
      User.all(:conditions => "`users`.remember_token IS NULL").each do |user|
        new_code = Authlogic::Random.friendly_token
        user.update_attribute(:remember_token, new_code)
      end
      t.change    :login             , :string , :null => false                # optional , you can use email instead             , or both
      t.change    :email             , :string , :null => false                # optional , you can use login instead             , or both
      t.change    :crypted_password  , :string , :null => false                # optional , see below
      t.rename    :salt, :password_salt
      t.change    :password_salt     , :string , :null => false                # optional , but highly recommended
      t.rename    :remember_token, :persistence_token
      t.change    :persistence_token , :string , :null => false                # required
      t.remove    :remember_token_expires_at                                   # appears to be handled by perishable_token_valid_for setting in Authlogic
      t.rename    :reset_code, :perishable_token
      t.change    :perishable_token  , :string , :null => false                # optional , see Authlogic::Session::Perishability
      t.remove    :activation_code                                             # perishable_token used for both activation_code and reset_code

      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
      #t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      #t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      #t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      #t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      #t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      #t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      #t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns
    end
  end

  def self.down
    # Revert back to restful_authentication-compatible users table
    create_table "users", :force => true do |t|
      t.string   "login"
      t.string   "email"
      t.string   "crypted_password",          :limit => 40
      t.string   "salt",                      :limit => 40
      t.string   "remember_token"                                                 # this would be persistence_token in Authlogic
      t.datetime "remember_token_expires_at"                                      # appears to be handled by perishable_token_valid_for setting in Authlogic
      t.string   "activation_code",           :limit => 40                        # this would be perishable_token in Authlogic
      t.datetime "activated_at"                                                   # appears to not be used
      t.string   "state",                                   :default => "passive" # appears to not be used
      t.datetime "deleted_at"                                                     # appears to not be used
      t.timestamps
      t.boolean  "superuser",                               :default => false
      t.string   "reset_code"
    end
  end
end
