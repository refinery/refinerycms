module Refinery
  class PageSweeper < ActionController::Caching::Sweeper
    observe Page

    def after_create(page)
      expire_cache
    end

    def after_update(page)
      expire_cache
    end

    def after_destroy(page)
      expire_cache
    end

  protected
    def expire_cache
      # TODO: Where does page_cache_directory come from??
      return unless page_cache_directory
      page_cache_directory_path = Pathname.new(page_cache_directory.to_s)

      # Delete the full Cache
      if (cache_root = page_cache_directory_path.join('refinery', 'cache', 'pages')).directory?
        cache_root.rmtree
      end

      # Delete the pages index files (/refinery/cache/pages.html*)
      Pathname.glob(page_cache_directory_path.join('refinery', 'cache', 'pages.html*')).each do |cache_index|
        cache_index.delete
      end
    end
  end
end
