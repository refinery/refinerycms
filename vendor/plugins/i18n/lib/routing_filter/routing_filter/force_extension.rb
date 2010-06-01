require 'routing_filter/base'

module RoutingFilter
  class ForceExtension < Base
    attr_reader :extension, :exclude

    def initialize(*args)
      super
      @extension ||= 'html'
      @exclude = %r(^(http.?://[^/]+)?\/?$) if @exclude.nil?
    end

    def around_recognize(path, env, &block)
      extract_extension!(path) unless excluded?(path)
      yield(path, env)
    end

    def around_generate(*args, &block)
      returning yield do |result|
        url = result.is_a?(Array) ? result.first : result
        append_extension!(url) if append_extension?(url)
      end
    end

    protected

      def extract_extension!(path)
        path.sub! /\.#{extension}$/, ''
        $1
      end

      def append_extension?(url)
        !(url.blank? || excluded?(url) || mime_extension?(url))
      end

      def excluded?(url)
        case exclude
        when Regexp
          url =~ exclude
        when Proc
          exclude.call(url)
        end
      end

      def mime_extension?(url)
        url =~ /\.#{Mime::EXTENSION_LOOKUP.keys.join('|')}(\?|$)/
      end

      def append_extension!(url)
        url.replace url.sub(/(\?|$)/, ".#{extension}\\1")
      end

      def append_page!(url, page)
        url.replace "#{url}/pages/#{page}"
      end
  end
end
