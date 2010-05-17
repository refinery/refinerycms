module Admin::DashboardHelper

  def activity_message_for(record)
    if (activity = Refinery::Plugins.active.find_activity_by_model(record[:activity_class])).present? and activity.title.present?
      link = link_to  "<strong>#{pluralize(record[:count], record[:activity_class].name.underscore.gsub("_", " "))}</strong> #{(record[:count] != 1) ? "were" : "was"} created or updated",
                      eval("admin_#{record[:activity_class].name.underscore.pluralize}_url")

      message = "<td>#{refinery_icon_tag("#{activity.send "updated_image"}")}</td>"
      message << "<td>#{link}</td>"
      message << "<td class='time_ago'>last was #{time_ago_in_words(record[:latest_action]).gsub("about ", "")} ago</td>"
      message.html_safe
    end
  end

end
