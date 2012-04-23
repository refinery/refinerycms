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
      
      # Delete the pages index file (/refinery/cache/pages.html)
      if (cache_index = page_cache_directory_path.join('refinery', 'cache', 'pages.html')).file?
        cache_index.delete
      end
      
      # Delete the gzipped pages index file (/refinery/cache/pages.html.gz)
      if (cache_index_gz = page_cache_directory_path.join('refinery', 'cache', 'pages.html.gz')).file?
        cache_index_gz.delete
      end
    end
  end
end
