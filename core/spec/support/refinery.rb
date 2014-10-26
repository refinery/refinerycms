require 'refinerycms-testing'

RSpec.configure do |config|
  config.extend Refinery::Testing::ControllerMacros::Authentication, :type => :controller
  config.include Refinery::Testing::ControllerMacros::Routes, :type => :controller
  config.extend Refinery::Testing::FeatureMacros::Authentication, :type => :feature

  # set some config values so that image and resource factories don't fail to create
  config.before do
    Refinery::Images.max_image_size = 5_242_880 if defined?(Refinery::Images)
    Refinery::Resources.max_file_size = 52_428_800 if defined?(Refinery::Resources)
  end
end
