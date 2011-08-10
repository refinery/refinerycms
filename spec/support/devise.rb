require 'devise'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  
  config.include Devise::TestHelpers, :type => :controller
end
