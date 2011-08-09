Given /^I have no files$/ do
  ::Refinery::Resource.destroy_all
end

When /^I upload the file at "([^\"]*)"$/ do |file_path|
  Factory(:resource)
end
