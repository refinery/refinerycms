module ::Refinery
  module Admin
    class DialogsController < ::Refinery::AdminController
      TYPES = %w[image link]

      before_filter :find_dialog_type, :only => [:show]

      def index
        redirect_to refinery.admin_root_path
      end

      def show
        url_params = params.reject {|key, value|
          /(action)|(controller)/ === key
        }.merge(:id => nil)

        @iframe_src = if @dialog_type == 'image'
          refinery.insert_admin_images_path url_params.merge(:modal => true)
        elsif @dialog_type == 'link'
          refinery.link_to_admin_pages_dialogs_path url_params
        end

        render :layout => false
      end

      def from_dialog?
        true
      end

      protected
      def find_dialog_type
        error_404 if TYPES.exclude? params[:id].downcase

        @dialog_type = params[:id].downcase
      end

    end
  end
end
