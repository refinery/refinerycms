Given /^I have no files$/ do
  ::Refinery::Resource.destroy_all
end

When /^I upload the file at "([^\"]*)"$/ do |file_path|
  Factory(:resource)
end

Given /^I have no images$/ do
  ::Refinery::Image.destroy_all
end

When /^I upload the image at "([^\"]*)"$/ do |file_path|
  Factory(:image)
end
