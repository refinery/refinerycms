Given /^I have a refinery application$/ do
  FileUtils.mkdir(File.join(@app_root))
end

Then /^I should have a directory "([^"]*)"$/ do |name|
  File.exist?(File.join(@tmp_refinery_app_root, name)).should be_true
end

Then /^I should have a file "([^"]*)"$/ do |name|
  File.exist?(File.join(@tmp_refinery_app_root, name)).should be_true
end
