module InquiriesHelper

  def open_close_link(inquiry)
    if inquiry.open?
      link_to("Open", {:action => 'toggle_status', :id => inquiry.id},
                      {:title => "Click to close this inquiry"})
    else
      link_to("Closed", {:action => 'toggle_status', :id => inquiry.id},
                        {:title => "Click to open this inquiry back up"})
    end
  end

end
