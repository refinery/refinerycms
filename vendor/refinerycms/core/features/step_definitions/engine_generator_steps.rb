require File.expand_path("../../../lib/generators/refinery_engine/refinery_engine_generator", __FILE__)

Before do
  @engine_generator_root  = File.expand_path('../../../', __FILE__)
  @tmp_refinery_app_name  = "tmp_refinery_app"
  @tmp_refinery_app_root  = File.join(@engine_generator_root, @tmp_refinery_app_name)
  @app_root = @tmp_refinery_app_root
end

After do
  FileUtils.rm_rf(@tmp_refinery_app_root)
end

When /^I generate an engine with the arguments of "([^"]*)"$/ do |arguments|
  generator = RefineryEngineGenerator.new(arguments.split(" "))
  generator.destination_root = @app_root
  generator.options = {:quiet => true}
  generator.generate
end
