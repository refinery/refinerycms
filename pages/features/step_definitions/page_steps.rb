Given /^I (only )?have a page titled "?([^\"]*)"? with a custom url "?([^\"]*)"?$/ do |only, title, link_url|
  ::Refinery::Page.delete_all if only

  ::Refinery::Page.create(:title => title, :link_url => link_url)
end

Given /^the page titled "?([^\"]*)"? has a menu match "?([^\"]*)"?$/ do |title, menu_match|
  ::Refinery::Page.by_title(title).first.update_attribute(:menu_match, menu_match)
end

Given /^the page titled "?([^\"]*)"? is set to skip to first child$/ do |title|
  Page.by_title(title).first.update_attribute(:skip_to_first_child, true)
end

Given /^I (only )?have pages titled "?([^\"]*)"?$/ do |only, titles|
  ::Refinery::Page.delete_all if only
  titles.split(', ').each do |title|
    ::Refinery::Page.create(:title => title)
  end
end

Given /^I have no pages$/ do
  ::Refinery::Page.delete_all
end

Given /^I (only )?have a page titled "?([^\"]*)"?$/ do |only, title|
  ::Refinery::Page.delete_all if only
  ::Refinery::PagePart.delete_all if only
  page = ::Refinery::Page.create(:title => title)
  page.parts << ::Refinery::PagePart.new(:title => 'testing', :position => 0)
  page
end

Given /^the page titled "?([^\"]*)"? is a child of "?([^\"]*)"?$/ do |title, parent_title|
  parent_page = ::Refinery::Page.by_title(parent_title).first
  ::Refinery::Page.by_title(title).first.update_attribute(:parent_id, parent_page.id)
end

Given /^the page titled "?([^\"]*)"? is not shown in the menu$/ do |title|
  ::Refinery::Page.by_title(title).first.update_attribute(:show_in_menu, false)
end

Given /^the page titled "?([^\"]*)"? is draft$/ do |title|
  ::Refinery::Page.by_title(title).first.update_attribute(:draft, true)
end

Then /^I should have ([0-9]+) pages?$/ do |count|
  ::Refinery::Page.count.should == count.to_i
end

Then /^I should have a page at \/(.+)$/ do |url|
  ::Refinery::Page.all.count{|page| page.url[:path].to_s.include?(url)}.should == 1
end

Then /^I should have (\d+) page_parts$/ do |count|
  ::Refinery::PagePart.count.should == count.to_i
end

Given /^I have frontend locales "?([^\"]*)"?/ do |locales|
  ::Refinery::Setting.set(:i18n_translation_frontend_locales, {:value => locales.split(', '), :scoping => 'refinery'})
end
