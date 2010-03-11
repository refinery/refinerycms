module InquiriesHelper

  def open_close_link(inquiry)
    if inquiry.open?
      link_to(t(:open), {:action => 'toggle_status', :id => inquiry.id},
                      {:title => t(:click_to_close_this_inquiry)})
    else
      link_to(t(:closed), {:action => 'toggle_status', :id => inquiry.id},
                        {:title => t(:click_to_open_this_inquiry_back_up)})
    end
  end

end
