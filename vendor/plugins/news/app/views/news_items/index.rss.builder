xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    # Required to pass W3C validation.
    xml.atom :link, nil, {
      :href => news_items_url(:format => 'rss'),
      :rel => 'self', :type => 'application/rss+xml'
    }

    # Feed basics.
    xml.title             page_title
    xml.description       @page[:body].gsub(/<\/?[^>]*>/, "")
    xml.link              news_items_url(:format => 'rss')

    # News items.
    @news_items.each do |news_item|
      xml.item do
        xml.title         news_item.title
        xml.link          news_item_url(news_item)
        xml.description   truncate(news_item.body, :length => 200, :preserve_html_tags => true)
        xml.pubDate       news_item.publish_date.to_s(:rfc822)
        xml.guid          news_item_url(news_item)
      end
    end
  end
end