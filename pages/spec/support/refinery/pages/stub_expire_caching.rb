RSpec.configure do |config|
  config.before do
    Refinery::Pages::Caching.any_instance.stub(:expire!)
  end
end
