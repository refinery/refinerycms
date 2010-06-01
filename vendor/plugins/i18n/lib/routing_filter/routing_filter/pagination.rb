require 'routing_filter/base'

module RoutingFilter
  class Pagination < Base
    def around_recognize(path, env, &block)
      page = extract_page!(path)
      returning yield(path, env) do |params|
        params[:page] = page.to_i if page
      end
    end

    def around_generate(*args, &block)
      page = args.extract_options!.delete(:page)
      returning yield do |result|
        if page && page != 1
          url = result.is_a?(Array) ? result.first : result
          append_page!(url, page)
        end
      end
    end

    protected

      def extract_page!(path)
        path.sub! %r(/pages/([\d]+)/?$), ''
        $1
      end

      def append_page!(url, page)
        url.sub!(/($|\?)/) { "/pages/#{page}#{$1}" }
      end
  end
end
