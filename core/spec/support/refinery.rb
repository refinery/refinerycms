require 'refinerycms-testing'

RSpec.configure do |config|
  config.extend  Refinery::Testing::ControllerMacros::Authentication, :type => :controller
  config.include Refinery::Testing::ControllerMacros::Methods, :type => :controller
  config.extend  Refinery::Testing::RequestMacros::Authentication, :type => :request
  config.include Refinery::Testing::UrlHelper
end
