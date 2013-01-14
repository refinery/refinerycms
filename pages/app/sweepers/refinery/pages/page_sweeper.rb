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
      def caching
        @caching ||= Caching.new(ActionController::Base.page_cache_directory)
      end

      def expire_cache!
        caching.expire!
      end

    end
  end
end
