Before do
  @theme_generator_root  = File.join(File.dirname(__FILE__), "/../../")
  @tmp_refinery_app_name  = "tmp_refinery_app"
  @tmp_refinery_app_root  = File.join(@theme_generator_root, @tmp_refinery_app_name)
  @app_root = @tmp_refinery_app_root
  Rails::Generator::Base.append_sources(Rails::Generator::PathSource.new(:plugin, "#{@theme_generator_root}/generators/"))
end

After do
  FileUtils.rm_rf(@tmp_refinery_app_root)
end

Given /^I have a refinery application$/ do
  FileUtils.mkdir(File.join(@app_root))
end

When /^I generate a theme with the name of "([^"]*)"$/ do |name|
  Rails::Generator::Scripts::Generate.new.run([:theme, name], {:destination => @app_root, :quiet => true})
end

Then /^I should have a directory named "([^"]*)"$/ do |name|
  File.exist?(File.join(@tmp_refinery_app_root, '/themes', name)).should be_true
end

Then /^I should have a stylsheet named "([^"]*)"$/ do |name|
  File.exist?(File.join(@tmp_refinery_app_root, '/themes', name)).should be_true
end

Then /^I should have a layout named "([^"]*)"$/ do |name|
  File.exist?(File.join(@tmp_refinery_app_root, '/themes', name)).should be_true
end

Then /^I should have a "([^"]*)"$/ do |name|
  File.exist?(File.join(@tmp_refinery_app_root, '/themes', 'modern', name)).should be_true
end

