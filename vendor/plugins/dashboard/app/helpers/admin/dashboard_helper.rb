module Admin::DashboardHelper

  def activity_message_for(record)
    if (activity = Refinery::Plugins.active.find_activity_by_model(record.class)).present? and activity.title.present?
      title = h(record.send(activity.title))

      # next work out which action occured
      action = record.updated_at.eql?(record.created_at) ? "created" : "updated"

      # now create a link to the notification's corresponding record.
      link_to("#{truncate(title.to_s, :length => 45)} #{record.class.name.titleize.downcase} was #{action}",
              eval("#{activity.url}(#{activity.nesting("record")}record)"),
              :title => "See '#{title}'")
    end
  end

end
