xml.instruct!

xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  @locales.each do |locale|
    ::I18n.locale = locale
    # request appropriate host & port depending on i18n mode
    localized_domain_name = ::Refinery::I18n.domain_name_for_locale(locale)
    host_with_port = (::Refinery::I18n.domain_name_enabled? && localized_domain_name) ?
      [localized_domain_name, ":", request.port].join : request.host_with_port
    
    ::Refinery::Page.live.in_menu.includes(:parts).each do |page|
     # exclude sites that are external to our own domain.
     page_url = if page.url.is_a?(Hash)
       # This is how most pages work without being overriden by link_url
       page.url.merge({:only_path => false})
     elsif page.url.to_s !~ /^http/
       # handle relative link_url addresses.
       [request.protocol, host_with_port, page.url].join
     end
     page_url[:host] = localized_domain_name if (localized_domain_name && page_url.is_a?(Hash))
     # Add XML entry only if there is a valid page_url found above.
     xml.url do
       xml.loc refinery.url_for(page_url)
       xml.lastmod page.updated_at.to_date
     end if page_url.present? and page.show_in_menu?
    end
  end

end
