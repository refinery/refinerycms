class CreateUserPlugins < ActiveRecord::Migration
  def self.up
		rename_column :users, :plugins, :plugins_column
	
		create_table :user_plugins do |t|
			t.integer :user_id
			t.string :title
		end
		
		add_index :user_plugins, :title
		add_index :user_plugins, [:user_id, :title], :unique => true, :name => "index_unique_user_plugins"
		
		User.find(:all).each do |user|
			user.plugins_column.each do |plugin_title|
				user.plugins.create(:title => plugin_title)
			end
		end
		
		remove_column :users, :plugins_column
  end

  def self.down
		drop_table :user_plugins
  end
end
