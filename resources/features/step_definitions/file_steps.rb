Given /^I have no files$/ do
  ::Refinery::Resource.destroy_all
end

When /^I attach the file at "([^\"]*)"$/ do |file_path|
  attach_file('resource_file', File.join(File.expand_path('../../uploads/', __FILE__), file_path))
end

Then /^the file "([^\"]*)" should have uploaded successfully$/ do |file_name|
  ::Refinery::Resource.find_by_file_name(file_name).nil?.should == false
end

And /^I should have ([0-9]+) files?$/ do |number|
  ::Refinery::Resource.count.should == number.to_i
end

When /^I upload the file at "([^\"]*)"$/ do |file_path|
  visit new_refinery_admin_resource_path
  attach_file('resource_file', File.join(File.expand_path('../../uploads/', __FILE__), file_path))
  click_button 'Save'
end
