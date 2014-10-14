RSpec.configure do |config|
  config.around(:each, :selenium) do |example|
    begin
      Capybara.javascript_driver = :selenium
      example.call
    ensure
      Capybara.javascript_driver = :poltergeist
    end
  end
end