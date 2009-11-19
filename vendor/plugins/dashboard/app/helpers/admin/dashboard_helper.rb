module Admin::DashboardHelper

  def activity_message_for(record)
    unless (activity = Refinery::Plugins.active.find_activity_by_model(record.class)).nil? or activity.title.blank?
      title = eval "record.#{activity.title}"
      link = link_to truncate(title, :length => 60),
        eval("#{activity.url_prefix}admin_#{record.class.name.underscore.downcase}_url(record)"),
        :title => "See '#{title}'"

      # next work out which action occured and how long ago it happened
      action = record.updated_at.eql?(record.created_at) ? "created" : "updated"

      message = "<td>#{refinery_icon_tag("#{eval("activity.#{action}_image")}")}</td>"
      message << "<td>#{link} #{record.class.name.titleize.downcase} was #{action}</td>"
      message << "<td align='right'>#{time_ago_in_words(eval("record.#{action}_at"))} ago</td>"
    end
  end

end
