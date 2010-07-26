Given /^I have no inquiries$/ do
  Inquiry.delete_all
end

Then /^I should have ([0-9]+) inquiries?$/ do |count|
  Inquiry.count.should == count.to_i
end