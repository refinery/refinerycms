module Refinery
  module Admin
    class CoreController < ::Refinery::AdminController
      def index
        redirect_to refinery_admin_root_path
      end

      def update_plugin_positions
        current_refinery_user.plugins.update_positions(params[:menu])
        render :nothing => true
      end
    end
  end
end
