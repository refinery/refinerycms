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
			p = user[:plugins_column].is_a?(String) ? user[:plugins_column].split(',') : user[:plugins_column]
			
			p.each do |plugin_title|
				user.plugins.create(:title => plugin_title)
			end
		end
		
		remove_column :users, :plugins_column
  end

  def self.down
		add_column :users, :plugins_column, :string
		
		User.find(:all).each do |user|
			plugins_for_user = []
			
			UserPlugin.find(:all, :conditions => "user_id = #{user.id}").each do |plugin|
				plugins_for_user.push(plugin.title)
			end
			
			user.update_attribute(:plugins_column, plugins_for_user)
		end
	
		drop_table :user_plugins
		
		rename_column :users, :plugins_column, :plugins
  end
end
