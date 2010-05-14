class Admin::DashboardController < Admin::BaseController

  def index
    @recent_activity = []

    Refinery::Plugins.active.each do |plugin|
      begin
        plugin.activity.each do |activity|
          @recent_activity << {
            :activity_class => activity.class,
            :count => activity.class.count(:conditions => activity.conditions),
            :latest_action => activity.class.maximum(:updated_at)
          }
        end
      rescue
        logger.info "#{$!.class.name} raised while getting recent activity for dashboard."
        logger.warn $!.backtrace.collect { |b| " > #{b}" }.join("\n")
      end
    end

    @recent_activity = @recent_activity.collect{|a| a if a[:count] > 0}.compact.sort{|a,b| b[:latest_action] <=> a[:latest_action]}
  end

end
