xml.instruct!

xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  @locales.each do |locale|
    ::I18n.locale = locale
    Page.live.in_menu.includes(:parts).each do |page|
     # exclude sites that are external to our own domain.
     page_url = if page.url.is_a?(Hash)
       # This is how most pages work without being overriden by link_url
       page.url.merge({:only_path => false})
     elsif page.url.to_s !~ /^http/
       # handle relative link_url addresses.
       [request.protocol, request.host_with_port, page.url].join
     end

     # Add XML entry only if there is a valid page_url found above.
     xml.url do
       xml.loc url_for(page_url)
       xml.lastmod page.updated_at.to_date
     end if page_url.present? and page.show_in_menu?
    end
  end

end
