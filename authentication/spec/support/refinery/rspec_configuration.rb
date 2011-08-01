::RSpec.configure do |config|
  config.include ::Devise::TestHelpers, :type => :controller
  config.extend Refinery::ControllerMacros, :type => :controller
  config.extend Refinery::RequestMacros, :type => :request
end
