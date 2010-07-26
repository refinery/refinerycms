Given /^I have no files$/ do
  Resource.delete_all
end

When /^I attach the file at "([^"]*)"$/ do |file_path|
  attach_file('resource[uploaded_data]', File.join(Rails.root, file_path))
end

Then /^the file "([^"]*)" should have uploaded successfully$/ do |file_name|
  Resource.find_by_filename(file_name).nil?.should == false
end

Then /^I should have (\d+) file$/ do |number|
  Resource.count.should == number.to_i
end

