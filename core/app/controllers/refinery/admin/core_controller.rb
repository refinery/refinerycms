module Refinery
  module Admin
    class CoreController < ::Refinery::AdminController
      def update_plugin_positions
        params[:menu].each_with_index do |plugin_name, index|
          if (plugin = current_refinery_user.plugins.find_by_name(plugin_name))
            plugin.update_attributes position: index
          end
        end
        render :nothing => true
      end
    end
  end
end
