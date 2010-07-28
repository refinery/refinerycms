Before do
  @plugin_generator_root  = File.join(File.dirname(__FILE__), "/../../")
  @tmp_refinery_app_name  = "tmp_refinery_app"
  @tmp_refinery_app_root  = File.join(@plugin_generator_root, @tmp_refinery_app_name)
  @app_root = @tmp_refinery_app_root
  Rails::Generator::Base.append_sources(Rails::Generator::PathSource.new(:plugin, "#{@plugin_generator_root}/generators/"))
end

After do
  FileUtils.rm_rf(@tmp_refinery_app_root)
end

When /^I generate a plugin with the arguments of "([^"]*)"$/ do |arguments|
  Rails::Generator::Scripts::Generate.new.run((["refinery_plugin"] | arguments.split(" ")), {:quiet => true, :destination => @app_root})
end

