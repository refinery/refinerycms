class CreateRefinerycmsLocalizationUsers < ActiveRecord::Migration
  # Treat localizations as already present.
  def up
    create_table :refinery_user_locales do |t|
      t.integer :user_id
      t.string :locale, limit: 20  # RFC 1766
    end
    # 'en' is the master language. Ensure every user has access to it.
    #execute "select into refinery_localizations_users user_id, 'en' from refinery_users;"
    add_index :refinery_user_locales, :user_id
  end

  def down
    drop_table :refinery_user_locales
  end
end
