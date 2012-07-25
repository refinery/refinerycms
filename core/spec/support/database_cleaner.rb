require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation#:transaction
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # config.around(:each, :js) do |example|
  #   DatabaseCleaner.strategy = :truncation
  #   example.call
  #   DatabaseCleaner.strategy = :transaction
  # end
end
