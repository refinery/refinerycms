RSpec.configure do |config|
  config.include ::Devise::TestHelpers, :type => :controller   
  config.extend Refinery::Authentication::ControllerMacros, :type => :controller
  config.extend Refinery::Authentication::RequestMacros, :type => :request
end
