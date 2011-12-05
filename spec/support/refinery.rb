require 'refinerycms-testing'

RSpec.configure do |config|
  config.extend Refinery::Testing::ControllerMacros::Authentication, :type => :controller
  config.extend Refinery::Testing::RequestMacros::Authentication, :type => :request

  # set some config values so that image and resource factories don't fail to create
  config.before(:each) do
    Refinery::Images.config.max_image_size = 5242880
    Refinery::Resources.config.max_file_size = 52428800
  end
end
