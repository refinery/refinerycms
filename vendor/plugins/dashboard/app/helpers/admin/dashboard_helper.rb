module Admin::DashboardHelper

  def activity_message_for(record)
    #TODO Update translation & translate message properly
    if (activity = Refinery::Plugins.active.find_activity_by_model(record.class)).present? and activity.title.present?
      title = h(record.send activity.title)
      link = link_to  truncate(title.to_s, :length => 45),
                      eval("#{activity.url}(#{activity.nesting("record")}record)"),
                      :title => t('.see', :what => title)

      # next work out which action occured and how long ago it happened
      action = record.updated_at.eql?(record.created_at) ? :created : :updated

      message = "<td>#{refinery_icon_tag("#{activity.send "#{action}_image"}")}</td>"
      message << "<td>#{link} #{record.class.human_name.titleize.downcase} #{t(action)}</td>"
      message << "<td class='time_ago'>#{t(:ago, :time => time_ago_in_words(record.send "#{action}_at"))}</td>"
    end
  end

end
