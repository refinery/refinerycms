if Capybara.javascript_driver == :selenium
  require 'selenium-webdriver'
  require 'selenium/webdriver/firefox'

  if defined?(Selenium::WebDriver::Firefox::Launcher) && Selenium::WebDriver::Platform.mac?
    # Run firefox in the background, on OS X
    Selenium::WebDriver::Firefox::Launcher.class_eval do
      def start
        assert_profile
        @binary.start_with @profile, @profile_dir, ''
      end
    end
  end
end
