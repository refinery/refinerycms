class UpdateLinkUrlOnPagesFromInquiriesNewToContact < ActiveRecord::Migration
  def self.up
    Page.find_all_by_link_url('/inquiries/new').each do |page|
      page.update_attributes({
        :link_url => '/contact',
        :menu_match => "^/(inquiries|contact).*$"
      })
    end
    Page.find_all_by_menu_match('^/inquiries/thank_you$').each do |page|
      page.update_attributes({
        :link_url => '/contact/thank_you',
        :menu_match => '^/(inquiries|contact)/thank_you$'
      })
    end
  end

  def self.down
    Page.find_all_by_link_url('/contact/thank_you').each do |page|
      page.update_attributes({
        :link_url => nil,
        :menu_match => '^/inquiries/thank_you$'
      })
    end
    Page.find_all_by_link_url('/contact').each do |page|
      page.update_attributes({
        :link_url => '/inquiries/new',
        :menu_match => '^/inquiries.*$'
      })
    end
  end
end
