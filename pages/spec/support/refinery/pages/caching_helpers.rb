module CachingHelpers
  def cached_directory
    "spec/dummy/public/refinery/cache/pages"
  end

  def cached_file_path(page)
    "#{cached_directory}#{refinery.page_path(page)}.html"
  end

  def cache_page(page)
    allow_any_instance_of(Refinery::PagesController).to receive(:refinery_user?).and_return(false)
    visit refinery.page_path(page)
    allow_any_instance_of(Refinery::PagesController).to receive(:refinery_user?).and_call_original
  end

  RSpec::Matchers.define :be_cached do
    match do |page|
      File.exists?(cached_file_path(page))
    end
  end

end
