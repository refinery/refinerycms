module RoutingFilter
  class Locale < Base

    def around_recognize(path, env, &block)
      if Refinery::I18n.enabled? 
        locale = nil
        path.sub! %r(^/(([a-zA-Z\-_])*)(?=/|$)) do locale = $1; '' end
        returning yield do |params|
          params[:locale] = (locale ||= I18n.default_locale)
        end
      else
        returning yield do |result| result end
      end
    end

    def around_generate(*args, &block)
      if Refinery::I18n.enabled?
        locale = args.extract_options!.delete(:locale) || I18n.default_locale
        returning yield do |result|
          result.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{locale}#{$2}" }
        end
      else
        returning yield  do |result| result end
      end
    end

  end
end
