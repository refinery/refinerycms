xml.instruct!

base_url =  "http://#{request.host_with_port}"
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  @pages.each do |page|
   xml.url do
     xml.loc base_url + url_for(page.url)
     xml.lastmod page.updated_at.to_date
   end
  end

end