module RoutingFilter
  class RefineryLocales < Filter

    def around_recognize(path, env, &block)
      if ::Refinery::I18n.enabled?
        locale = nil
        if path =~ %r{^/(#{::Refinery::I18n.locales.keys.join('|')})/}
          if path !~ %r{^/(sessions?|admin|refinery|wymiframe)}
            path.sub! %r(^/(([a-zA-Z\-_])*)(?=/|$)) do
              locale = $1
              ::I18n.locale = locale
              ''
            end
          end
        else
          ::I18n.locale = ::Refinery::I18n.default_frontend_locale
        end

        yield.tap do |params|
          unless path =~ %r{^/(admin|refinery|wymiframe)} or ::I18n.locale == ::Refinery::I18n.default_frontend_locale
            params[:locale] = (locale.presence || ::Refinery::I18n.current_frontend_locale)
          end
        end
      else
        yield.tap do |result|
          result
        end
      end
    end

    def around_generate(params, &block)
      if ::Refinery::I18n.enabled?
        locale = params.delete(:locale) || ::I18n.locale
        yield.tap do |result|
          if (locale != ::Refinery::I18n.default_frontend_locale and result !~ %r{^/(refinery|wymiframe)})
            result.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{locale}#{$2}" }
          end
          result
        end
      else
        yield.tap do |result|
          result
        end
      end
    end

  end
end
