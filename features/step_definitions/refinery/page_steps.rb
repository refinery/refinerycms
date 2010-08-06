Given /^I (only )?have a page titled "([^"]*)" with a custom url "([^"]*)"?$/ do |only, title, link_url|
  Page.delete_all if only

  Page.create(:title => title,
              :link_url => link_url)
end

Given /^I (only )?have pages titled "?([^"]*)"?$/ do |only, titles|
  Page.delete_all if only
  titles.split(', ').each do |title|
    Page.create(:title => title)
  end
end

Given /^I have no pages$/ do
  Page.delete_all
end

Given /^I have test page titled "([^"]*)"$/ do |title|
  Page.create(:title => title)
end

Then /^I should have ([0-9]+) pages?$/ do |count|
  Page.count.should == count.to_i
end

Then /^I should have a page at \/(.+)$/ do |url|
  Page.all.count{|page| page.url[:path].to_s.include?(url)}.should == 1
end
