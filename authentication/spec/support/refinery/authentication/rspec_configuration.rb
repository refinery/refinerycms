::RSpec.configure do |config|
  config.include ::Devise::TestHelpers, :type => [:controller, :request]
  config.include ::Refinery::Authentication::Macros, :type => [:controller, :request]
end
