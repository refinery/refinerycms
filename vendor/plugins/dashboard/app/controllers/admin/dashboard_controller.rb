class Admin::DashboardController < Admin::BaseController

  def index
    @recent_activity = []
    $plugins.each do |plugin|
      plugin.activity.each do |activity|
        @recent_activity += activity.class.find(:all, :order => activity.order, :limit => activity.limit, :conditions => activity.conditions)
      end
    end

    @recent_activity = @recent_activity.sort{|x,y| y.updated_at <=> x.updated_at}[0..((RefinerySetting.activity_show_limit ||= 15)-1)]
  end

end