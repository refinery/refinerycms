module Refinery
  module Pages
    class PageSweeper < ActionController::Caching::Sweeper
      observe Page

      def after_save(page)
        expire_cache!
      end

      def after_destroy(page)
        expire_cache!
      end

      protected
      def cache_directory
        page_cache_directory
      end

      def caching
        @caching ||= Caching.new(cache_directory)
      end

      def expire_cache!
        caching.expire!
      end

    end
  end
end
