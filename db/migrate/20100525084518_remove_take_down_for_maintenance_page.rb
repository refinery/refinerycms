class RemoveTakeDownForMaintenancePage < ActiveRecord::Migration
  def self.up
    if (page = Page.find_by_menu_match("^/maintenance$")).present?
      page.destroy!
    end
  end

  def self.down
    down_for_maintenance_page = Page.create(:title => "Down for maintenance",
                :menu_match => "^/maintenance$",
                :show_in_menu => false,
                :position => (Page.maximum(:position) + 1))
    down_for_maintenance_page.parts.create({
                  :title => "Body",
                  :body => "<p>Our site is currently down for maintenance. Please try back later.</p>",
                  :position => 0
                })
  end
end
