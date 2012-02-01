xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    # Required to pass W3C validation.
    xml.atom :link, nil, {
      :href => refinery.admin_dashboard_index_path(:format => 'rss'),
      :rel => 'self', :type => 'application/rss+xml'
    }

    # Feed basics.
    xml.title             "Refinery Updates"
    xml.description       "See the recent activity on your Refinery site."
    xml.link              refinery.admin_dashboard_index_path(:format => 'rss')

    # Recent activity.
    @recent_activity.each do |change|
      xml.item do
        xml.title         change.class
        #xml.link          link
        xml.description   activity_message_for change
        #xml.pubDate       date.to_s(:rfc822)
        #xml.guid          unique
      end
    end
  end
end
