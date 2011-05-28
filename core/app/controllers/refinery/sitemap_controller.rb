module ::Refinery
  class SitemapController < ::Refinery::FastController
    layout nil

    def index
      headers['Content-Type'] = 'application/xml'

      respond_to do |format|
        format.xml do
          @locales = if defined?(::Refinery::I18n) && ::Refinery::I18n.enabled?
                       ::Refinery::I18n.frontend_locales
                     else
                       [::I18n.locale]
                     end
        end
      end
    end

  end
end
