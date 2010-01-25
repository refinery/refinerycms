class MigrateOldPluginTitlesToPluginNamesForUsers < ActiveRecord::Migration
  def self.up
    User.all.each do |user|
      user.plugins.each do |plugin|
        plugin.update_attribute(:name, case plugin.name
        when "Users"
          "refinery_users"
        when "Dashboard"
          "refinery_dashboard"
        when "Images"
          "refinery_images"
        when "Inquiries"
          "refinery_inquiries"
        when "News"
          "refinery_news"
        when "Pages"
          "refinery_pages"
        when "Refinery"
          "refinery_core"
        when "Settings"
          "refinery_settings"
        when "Resources"
          "refinery_resources"
        else
          plugin.name
        end)
      end
    end
  end

  def self.down
    User.all.each do |user|
      user.plugins.each do |plugin|
        plugin.update_attribute(:name, case plugin.name
        when "refinery_users"
          "Users"
        when "refinery_dashboard"
          "Dashboard"
        when "refinery_images"
          "Images"
        when "refinery_inquiries"
          "Inquiries"
        when "refinery_news"
          "News"
        when "refinery_pages"
          "Pages"
        when "refinery_core"
          "Refinery"
        when "refinery_settings"
          "Settings"
        when "refinery_resources"
          "Resources"
        else
          plugin.name
        end)
      end
    end
  end
end
