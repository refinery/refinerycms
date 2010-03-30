require 'routing_filter/base'
require 'routing_filter/locale'
module RoutingFilter
  class Locale < Base

    def around_recognize(path, env, &block)
      locale = nil
      path.sub! %r(^/([a-zA-Z]{2})(?=/|$)) do locale = $1; '' end
      returning yield do |params|
        params[:locale] = (locale ||= 'en')
      end
    end

    def around_generate(*args, &block)
      locale = args.extract_options!.delete(:locale) || 'uk'
      returning yield do |result|
        # we want to ensure we're not routing the admin urls.
        if ::RoutingFilter::Locale.i18n_enabled? and locale != 'en' and !(result =~ %r(^/admin))
          result.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{locale}#{$2}" }
        end
      end
    end

    class << self
      def i18n_enabled?
        RefinerySetting.find_or_set(:refinery_i18n_enabled, false)
      end
    end
  end
end
