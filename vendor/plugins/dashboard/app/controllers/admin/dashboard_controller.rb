class Admin::DashboardController < Admin::BaseController

  def index
    @recent_activity = []

    Refinery::Plugins.active.each do |plugin|
      begin
        plugin.activity.each do |activity|
          @recent_activity += activity.class.find(:all,
            :conditions => activity.conditions,
            :order => activity.order,
            :limit => activity.limit
          )
        end
      rescue
        logger.warn "#{$!.class.name} raised while getting recent activity for dashboard."
        logger.warn $!.message
        logger.warn $!.backtrace.collect { |b| " > #{b}" }.join("\n")
      end
    end

    @recent_activity = @recent_activity.compact.sort { |x,y|
      y.updated_at <=> x.updated_at
    }.first(activity_show_limit=RefinerySetting.find_or_set(:activity_show_limit, 7))

    @recent_inquiries = Inquiry.latest(activity_show_limit)
  end

end
