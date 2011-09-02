require 'refinerycms-testing'

RSpec.configure do |config|
  config.extend Refinery::ControllerMacros::Authentication, :type => :controller
  config.extend Refinery::RequestMacros::Authentication, :type => :request
end
