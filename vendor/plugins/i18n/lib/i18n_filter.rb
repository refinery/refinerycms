module RoutingFilter
  class Locale < Base

    def around_recognize(path, env, &block)
      if Refinery::I18n.enabled?
        locale = nil
        path.sub! %r(^/(([a-zA-Z\-_])*)(?=/|$)) do locale = $1; '' end if path !~ %r{^/refinery}

        returning yield do |params|
          params[:locale] = (locale.presence || Refinery::I18n.current_locale)
        end
      else
        returning yield do |result| result end
      end
    end

    def around_generate(*args, &block)
      if Refinery::I18n.enabled?
        locale = args.extract_options!.delete(:locale) || Refinery::I18n.current_locale
        returning yield do |result|
          result.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{locale}#{$2}" } if result !~ %r{^/refinery}
          result
        end
      else
        returning yield  do |result| result end
      end
    end

  end
end
