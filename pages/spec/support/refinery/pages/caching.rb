ActionController::Base.class_eval do
  include ActionController::Caching::Pages
end

RSpec.configure do |config|
  config.before(:each) do
    Refinery::Pages::PageSweeper.any_instance.stub(:expire_cache!)
  end

  config.before(:each, :caching => true) do
    FileUtils.rm_rf "spec/dummy/public/refinery/cache"
    ActionController::Base.perform_caching = true
    Refinery::Pages.cache_pages_full = true
    Refinery::Pages::PageSweeper.any_instance.stub(:cache_directory).and_return(ActionController::Base.page_cache_directory)
    Refinery::Pages::PageSweeper.any_instance.unstub(:expire_cache!)
  end

  config.after(:each, :caching => true) do
    FileUtils.rm_rf "spec/dummy/public/refinery/cache"
    ActionController::Base.perform_caching = false
    Refinery::Pages.cache_pages_full = false
  end
end
