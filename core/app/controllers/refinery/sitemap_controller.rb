module ::Refinery
  class SitemapController < ::Refinery::FastController
    layout nil

    def index
      headers['Content-Type'] = 'application/xml'

      respond_to do |format|
        format.xml do
          @locales = Refinery::I18n.frontend_locales
        end
      end
    end

  end
end
