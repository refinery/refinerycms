require 'refinerycms-testing'

RSpec.configure do |config|
  config.extend Refinery::Testing::ControllerMacros::Authentication, :type => :controller
  config.include Refinery::Testing::ControllerMacros::Methods, :type => :controller
  config.extend Refinery::Testing::FeatureMacros::Authentication, :type => :feature
  config.include Warden::Test::Helpers

  # set some config values so that image and resource factories don't fail to create
  config.before do
    Refinery::Images.max_image_size = 5242880 if defined?(Refinery::Images)
    Refinery::Resources.max_file_size = 52428800 if defined?(Refinery::Resources)
  end

  config.after do
    Warden.test_reset!
  end
end
