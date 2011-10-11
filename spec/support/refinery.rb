require 'refinerycms-testing'

Refinery::Testing.load_factories

RSpec.configure do |config|
  config.extend Refinery::Testing::ControllerMacros::Authentication, :type => :controller
  config.extend Refinery::Testing::RequestMacros::Authentication, :type => :request

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
