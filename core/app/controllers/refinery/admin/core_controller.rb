module Refinery
  module Admin
    class CoreController < ::Refinery::AdminController
      def index
        redirect_to refinery_admin_root_path
      end
    end
  end
end
