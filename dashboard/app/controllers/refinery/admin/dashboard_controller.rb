module Refinery
  module Admin
    class DashboardController < Refinery::AdminController

      def index
        @recent_activity = []

        ::Refinery::Plugins.active.each do |plugin|
          begin
            plugin.activity.each do |activity|
              @recent_activity += activity.klass.where(activity.conditions).
                                                 order(activity.order).
                                                 limit(activity.limit)
            end
          rescue
            logger.warn "#{$!.class.name} raised while getting recent activity for dashboard."
            logger.warn $!.message
            logger.warn $!.backtrace.collect { |b| " > #{b}" }.join("\n")
          end
        end

        @recent_activity = @recent_activity.sort_by(&:updated_at).reverse.
                           first(Refinery::Dashboard.activity_show_limit)

        @recent_inquiries = if Refinery::Plugins.active.find_by_name("refinery_inquiries")
          Inquiry.latest(Refinery::Dashboard.activity_show_limit)
        else
          []
        end
      end

      def disable_upgrade_message
        Refinery::Core.show_internet_explorer_upgrade_message = false
        render :nothing => true
      end

    end
  end
end
