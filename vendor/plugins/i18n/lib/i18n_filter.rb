module RoutingFilter
  class Locale < Base

    def around_recognize(path, env, &block)
      if Refinery::I18n.enabled?
        locale = nil
        if path !~ %r{^/(refinery|wymiframe)} and I18n.locale != I18n.default_locale
          path.sub! %r(^/(([a-zA-Z\-_])*)(?=/|$)) do
            locale = $1;
            ''
          end
        end

        returning yield do |params|
          params[:locale] = (locale.presence || Refinery::I18n.current_locale) unless I18n.locale == I18n.default_locale
        end
      else
        returning yield do |result| result end
      end
    end

    def around_generate(*args, &block)
      if Refinery::I18n.enabled?
        locale = args.extract_options!.delete(:locale) || Refinery::I18n.current_locale
        returning yield do |result|
          if (locale != I18n.default_locale and result !~ %r{^/(refinery|wymiframe)})
            result.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{locale}#{$2}" }
          end
          result
        end
      else
        returning yield  do |result| result end
      end
    end

  end
end
