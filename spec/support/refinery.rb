require 'refinery/testing/factories'
require 'refinery/testing/controller_macros'
require 'refinery/testing/request_macros'

RSpec.configure do |config|
  config.extend Refinery::ControllerMacros::Authentication, :type => :controller
  config.extend Refinery::RequestMacros::Authentication, :type => :request
end
