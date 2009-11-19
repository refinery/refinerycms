class Admin::DashboardController < Admin::BaseController

  def index
    @recent_activity = []
    Refinery::Plugins.active.each do |plugin|
      plugin.activity.each do |activity|
        include_associations = []
        include_associations.push(:slugs) if activity.class.methods.include? "find_one_with_friendly" # wee performance gain if slugs are used.
        @recent_activity += activity.class.find(:all, :order => activity.order, :limit => activity.limit, :conditions => activity.conditions, :include => include_associations)
      end rescue nil
    end

    @recent_activity = @recent_activity.sort{|x,y| y.updated_at <=> x.updated_at}[0..((RefinerySetting.activity_show_limit ||= 15)-1)]
  end

end
