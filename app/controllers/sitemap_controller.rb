class SitemapController < ::Refinery::FastController
  layout nil

  def index
    headers['Content-Type'] = 'application/xml'

    respond_to do |format|
      format.xml do
        @pages = Page.live
      end
    end
  end

end