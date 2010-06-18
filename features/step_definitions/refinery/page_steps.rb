Given /^I have pages titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Page.create(:title => title)
  end
end

Given /^I have no pages$/ do
  Page.delete_all
end

Then /^I should have ([0-9]+) pages?$/ do |count|
  Page.count.should == count.to_i
end
