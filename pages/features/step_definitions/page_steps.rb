Given /^I (only )?have a page titled "?([^\"]*)"? with a custom url "?([^\"]*)"?$/ do |only, title, link_url|
  Page.delete_all if only

  Page.create(:title => title, :link_url => link_url)
end

Given /^the page titled "?([^\"]*)"? has a menu match "?([^\"]*)"?$/ do |title, menu_match|
  Page.by_title(title).first.update_attribute(:menu_match, menu_match)
end

Given /^I (only )?have pages titled "?([^\"]*)"?$/ do |only, titles|
  Page.delete_all if only
  titles.split(', ').each do |title|
    Page.create(:title => title)
  end
end

Given /^I have no pages$/ do
  Page.delete_all
end

Given /^I (only )?have a page titled "?([^\"]*)"?$/ do |only, title|
  Page.delete_all if only
  PagePart.delete_all if only
  page = Page.create(:title => title)
  page.parts << PagePart.new(:title => 'testing', :position => 0)
  page
end

Given /^the page titled "?([^\"]*)"? is a child of "?([^\"]*)"?$/ do |title, parent_title|
  Page.by_title(title).first.update_attribute(:parent, Page.by_title(parent_title).first)
end

Given /^the page titled "?([^\"]*)"? is not shown in the menu$/ do |title|
  Page.by_title(title).first.update_attribute(:show_in_menu, false)
end

Given /^the page titled "?([^\"]*)"? is draft$/ do |title|
  Page.by_title(title).first.update_attribute(:draft, true)
end

Then /^I should have ([0-9]+) pages?$/ do |count|
  Page.count.should == count.to_i
end

Then /^I should have a page at \/(.+)$/ do |url|
  Page.all.count{|page| page.url[:path].to_s.include?(url)}.should == 1
end

Then /^I should have (\d+) page_parts$/ do |count|
  PagePart.count.should == count.to_i
end
