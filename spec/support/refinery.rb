require 'refinerycms-testing'

RSpec.configure do |config|
  config.extend Refinery::Testing::ControllerMacros::Authentication, :type => :controller
  config.extend Refinery::Testing::RequestMacros::Authentication, :type => :request

  config.before(:each) do
    Refinery::Images.reset!
    Refinery::Resources::Options.reset!
    Refinery::Pages.reset!
  end

  config.after(:each) do
    Refinery::Images.reset!
    Refinery::Resources::Options.reset!
    Refinery::Pages.reset!
  end
end
