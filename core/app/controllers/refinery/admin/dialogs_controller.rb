module ::Refinery
  module Admin
    class DialogsController < ::Refinery::AdminController
      TYPES = %w[image link]

      before_action :find_dialog_type, :find_iframe_src, :only => [:show]

      def index
        redirect_to Refinery::Core.backend_path
      end

      def show
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

      def find_iframe_src
        if @dialog_type == 'image'
          @iframe_src = refinery.insert_admin_images_path(
            url_params.merge(:modal => true)
          )
        elsif @dialog_type == 'link'
          @iframe_src = refinery.link_to_admin_pages_dialogs_path url_params
        end
      end

      def url_params
        params.to_unsafe_h.reject { |key, value| /(action)|(controller)/ === key}.
               merge :id => nil
      end

    end
  end
end
