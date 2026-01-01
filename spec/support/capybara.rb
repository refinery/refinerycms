require 'rack/test'
require 'rspec/rails'
require 'capybara/rspec'
require 'selenium/webdriver'

# Disable Selenium Manager telemetry
ENV['SE_AVOID_STATS'] = 'true'

Capybara.register_driver :local_selenium do |app|
  options = Selenium::WebDriver::Options.firefox
  # options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1400,1080")

  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

Capybara.register_driver :local_selenium_headless do |app|
  options = Selenium::WebDriver::Options.firefox
  # options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--window-size=1400,1400")

  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

selenium_app_host = ENV.fetch("SELENIUM_APP_HOST") do
  Socket.ip_address_list
        .find(&:ipv4_private?)
        .ip_address
end

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
  config.default_driver = :local_selenium
  # config.default_driver = :selenium_chrome_https
  config.javascript_driver = :local_selenium_headless
  # config.javascript_driver = :selenium_chrome_headless_https
  config.server_host = selenium_app_host
  Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage)
end

RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    # `Capybara.app_host` is reset in the RSpec before_setup callback defined
    # in `ActionDispatch::SystemTesting::TestHelpers::SetupAndTeardown`, which
    # is annoying as hell, but not easy to "fix". Just set it manually every
    # test run.
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"

    # Allow Capybara and WebDrivers to access network if necessary
    driver = if example.metadata[:js]
      locality = ENV["SELENIUM_HOST"].present? ? :remote : :local
      headless = "_headless" if ENV["DISABLE_HEADLESS"].blank?

      "#{locality}_selenium#{headless}".to_sym
    else
      :rack_test
    end

    driven_by driver
  end
end
