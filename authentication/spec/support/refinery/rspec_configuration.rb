require 'database_cleaner'

::RSpec.configure do |config|
  config.include ::Devise::TestHelpers, :type => :controller
  config.extend Refinery::Authentication::ControllerMacros, :type => :controller
  config.extend Refinery::Authentication::RequestMacros, :type => :request

  DatabaseCleaner.strategy = :truncation

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
