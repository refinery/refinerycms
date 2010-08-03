Given /^I have no files$/ do
  Resource.delete_all
end

Given /^I have test file titled "([^"]*)"$/ do |file_name|
  Resource.create(:content_type => 'application/x-debian-package', :filename => file_name, :size => 5000)
end

When /^I attach the file at "([^"]*)"$/ do |file_path|
  attach_file('resource[uploaded_data]', File.join(Rails.root, file_path))
end

Then /^the file "([^"]*)" should have uploaded successfully$/ do |file_name|
  Resource.find_by_filename(file_name).nil?.should == false
end

And /^I should have ([0-9]+) files?$/ do |number|
  Resource.count.should == number.to_i
end

When /^I upload the file at "([^"]*)"$/ do |file_path|
  visit new_admin_resource_path
  attach_file('resource[uploaded_data]', File.join(Rails.root, file_path))
  click_button 'Save'
end

