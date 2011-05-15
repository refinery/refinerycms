Given /^I have no layouts$/ do
  Layout.delete_all
end

Given /^I (only )?have layouts titled "?([^\"]*)"?$/ do |only, titles|
  Layout.delete_all if only
  titles.split(', ').each do |title|
    Layout.create(:template_name => title)
  end
end

Then /^I should have ([0-9]+) layouts?$/ do |count|
  Layout.count.should == count.to_i
end
