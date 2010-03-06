class Admin::DashboardController < Admin::BaseController

  def index
    @recent_activity = []

    Refinery::Plugins.active.each do |plugin|
      begin
        plugin.activity.each do |activity|
          include_associations = []
          include_associations.push(:slugs) if activity.class.methods.include? "find_one_with_friendly" # wee performance gain if slugs are used.

          @recent_activity += activity.class.find(:all,
            :conditions => activity.conditions,
            :order => activity.order,
            :limit => activity.limit,
            :include => include_associations
          )
        end
      rescue
        logger.info "#{$!.class.name} raised while getting recent activity for dashboard."
        logger.warn $!.backtrace.collect { |b| " > #{b}" }.join("\n")
      end
    end

    @recent_activity = @recent_activity.compact.uniq.sort{|x,y| y.updated_at <=> x.updated_at}[0..(RefinerySetting.find_or_set(:activity_show_limit, 15)-1)]
  end

end
