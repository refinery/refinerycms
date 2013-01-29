module Refinery
  module Pages
    class Caching

      attr_reader :cache_dir

      def initialize(cache_dir = nil)
        @cache_dir = cache_dir
      end

      def expire!
        clear_caching!
        delete_static_files!
      end

      private
      delegate :cache, :to => Rails

      def cache_dir_valid?
        cache_dir.present? && cache_dir_path.directory?
      end

      def cache_dir_path
        Pathname.new cache_dir.to_s
      end

      def clear_caching!
        begin
          cache.delete_matched(/.*pages.*/)
        rescue NoMethodError, NotImplementedError
          warn "**** [REFINERY] The cache store you are using is not compatible with Rails.cache#delete_matched - clearing entire cache instead ***"
          cache.clear
        end
      end

      def delete_static_files!
        return unless cache_dir_valid?

        delete_page_cache_directory!
        delete_page_cache_index_file!
      end

      def delete_page_cache_directory!
        page_cache_root.rmtree if page_cache_root.directory?
      end

      def delete_page_cache_index_file!
        page_cache_index_file.delete if page_cache_index_file.file?
      end

      def page_cache_index_file
        Pathname.new "#{page_cache_root}.html"
      end

      def page_cache_root
        cache_dir_path.join 'refinery', 'cache', 'pages'
      end
    end
  end
end
