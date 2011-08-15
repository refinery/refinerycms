Given /^I have a refinery application$/ do
  FileUtils.mkdir(File.join(@app_root))
end

Then /^I should have a (?:directory|file) "([^\"]*)"$/ do |name|
  File.exist?(File.join(@tmp_refinery_app_root, name)).should be_true
end
