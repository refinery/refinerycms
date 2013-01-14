RSpec.configure do |config|
  config.before(:caching => false) do
    Refinery::Pages::Caching.any_instance.stub(:expire!)
  end

  config.before(:all, :caching => true) do
    # FileUtils.rm_rf("/refinery/cache/pages")
    ActionController::Base.perform_caching = true
    Refinery::Pages.cache_pages_full = true
  end

  config.after(:all, :caching => true) do
    # FileUtils.rm_rf("/refinery/cache/pages")
    ActionController::Base.perform_caching = false
    Refinery::Pages.cache_pages_full = false
  end
end