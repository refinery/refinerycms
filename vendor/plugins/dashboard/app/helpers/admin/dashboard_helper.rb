module Admin::DashboardHelper

  def activity_message_for(record)
    #TODO Update translation & translate message properly
    if (activity = Refinery::Plugins.active.find_activity_by_model(record.class)).present? and activity.title.present?
      # work out which action occured
      action = record.updated_at.eql?(record.created_at) ? "created" : "updated"

      # now create a link to the notification's corresponding record.
      link_to "#{h(record.send(activity.title))} #{record.class.name.titleize.downcase} was #{action}",
              eval("#{activity.url}(#{activity.nesting("record")}record)")
    end
  end

end
