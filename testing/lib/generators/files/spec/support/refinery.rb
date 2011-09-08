require 'refinerycms-testing'

RSpec.configure do |config|
  config.extend Refinery::ControllerMacros::Authentication, :type => :controller
  config.extend Refinery::RequestMacros::Authentication, :type => :request
  
  config.before(:each) do
    Refinery::Images::Options.reset!
    Refinery::Resources::Options.reset!
    Refinery::Pages::Options.reset!
  end
  
  config.after(:each) do
    Refinery::Images::Options.reset!
    Refinery::Resources::Options.reset!
    Refinery::Pages::Options.reset!
  end
end
