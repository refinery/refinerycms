class AddDownForMaintenancePage < ActiveRecord::Migration
  def self.up
    page = Page.create(:title => "Down for maintenance", :menu_match => "^/maintenance$", :show_in_menu => false)
    page.parts.create(:title => "body", :body => "<p>Our site is currently down for maintenance. Please try back later.</p>")
  end

  def self.down
    page = Page.find_by_menu_match("^/maintenance$")
    unless page.nil?
      page.parts.delete_all
      page.update_attributes({:menu_match => nil, :link_url => nil, :deletable => true})
      page.destroy
    end
  end
end
