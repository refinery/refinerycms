module Admin::DashboardHelper

  def activity_message_for(record)
    if (activity = Refinery::Plugins.active.find_activity_by_model(record.class)).present? and activity.title.present?
      title = record.send activity.title
      link = link_to  truncate(title.to_s, :length => 45),
                      eval("#{activity.url}(#{activity.nesting("record")}record)"),
                      :title => "See '#{title}'"

      # next work out which action occured and how long ago it happened
      action = record.updated_at.eql?(record.created_at) ? "created" : "updated"

      message = "<td>#{refinery_icon_tag("#{activity.send "#{action}_image"}")}</td>"
      message << "<td>#{link} #{record.class.name.titleize.downcase} was #{action}</td>"
      message << "<td class='time_ago'>#{time_ago_in_words(record.send "#{action}_at").gsub("about ", "")} ago</td>"
    end
  end

end
