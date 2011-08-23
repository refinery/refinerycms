require 'refinery/testing/factories'
require 'refinery/testing/controller_macros'
require 'refinery/testing/request_macros'

RSpec.configure do |config|
  config.extend Refinery::Testing::ControllerMacros::Authentication, :type => :controller
  config.extend Refinery::Testing::RequestMacros::Authentication, :type => :request
end
