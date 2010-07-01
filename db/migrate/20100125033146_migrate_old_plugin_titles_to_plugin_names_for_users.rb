class MigrateOldPluginTitlesToPluginNamesForUsers < ActiveRecord::Migration
  def self.up
    UserPlugin.find(:all, :conditions => {:user_id => nil}).each { |up| up.destroy }
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
        when "Pages"
          "refinery_pages"
        when "Refinery"
          "refinery_core"
        when "Settings"
          "refinery_settings"
        when "Resources"
          "refinery_files"
        else
          if (refinery_plugin = ::Refinery::Plugins.registered.find_by_title(plugin.name)).present? and
              refinery_plugin.name.present?
           refinery_plugin.name
          else
            plugin.name.gsub(" ", "_").downcase
          end
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
        when "refinery_pages"
          "Pages"
        when "refinery_core"
          "Refinery"
        when "refinery_settings"
          "Settings"
        when "refinery_files"
          "Resources"
        else
          plugin.name.titleize
        end)
      end
    end
  end
end
