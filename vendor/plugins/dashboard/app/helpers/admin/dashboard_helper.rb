module Admin::DashboardHelper

  def activity_message_for(record)
    unless (activity = Refinery::Plugins.active.find_activity_by_model(record.class)).nil? or activity.title.blank?
      title = record.send activity.title
      link = link_to truncate(title, :length => 45),
        eval("#{activity.url_prefix}admin_#{record.class.name.underscore.downcase}_url(record)"),
        :title => "#{t(:see)} '#{title}'"

      # next work out which action occured and how long ago it happened
      action = record.updated_at.eql?(record.created_at) ? :created : :updated

      message = "<td>#{refinery_icon_tag("#{activity.send "#{action}_image"}")}</td>"
      message << "<td>#{link} #{record.class.name.titleize.downcase} #{t(action)}</td>"
      message << "<td class='time_ago'>#{time_ago_in_words(record.send "#{action}_at")} #{t(:ago)}</td>"
    end
  end

end
