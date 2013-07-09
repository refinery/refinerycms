module CachingHelpers
  def cached_directory
    "spec/dummy/public/refinery/cache/pages"
  end

  def cached_file_path(page)
    "#{cached_directory}#{refinery.page_path(page)}.html"
  end

  def cache_page(page)
    Refinery::PagesController.any_instance.stub(:refinery_user?).and_return(false)
    visit refinery.page_path(page)
    Refinery::PagesController.any_instance.unstub(:refinery_user?)
  end

  RSpec::Matchers.define :be_cached do
    match do |page|
      File.exists?(cached_file_path(page))
    end
  end

end
