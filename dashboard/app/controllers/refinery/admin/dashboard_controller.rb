module Refinery
  module Admin
    class DashboardController < Refinery::AdminController

      def index
        @recent_inquiries = if Refinery::Plugins.active.find_by_name("refinerycms_inquiries")
          Refinery::Inquiries::Inquiry.latest(Refinery::Dashboard.activity_show_limit)
        else
          []
        end
      end

    end
  end
end
