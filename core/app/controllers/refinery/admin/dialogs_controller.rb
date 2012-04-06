module ::Refinery
  module Admin
    class DialogsController < ::Refinery::AdminController
      def index
        redirect_to refinery.admin_root_path
      end

      def show
        @dialog_type = params[:id].downcase

        url_params = params.reject {|key, value| key =~ /(action)|(controller)/}

        @iframe_src = if @dialog_type == 'image'
          refinery.insert_admin_images_path(url_params.merge(:id => nil, :modal => true))
        elsif @dialog_type == 'link'
          refinery.link_to_admin_pages_dialogs_path(url_params.merge(:id => nil))
        end

        render :layout => false
      end

      def from_dialog?
        true
      end

    end
  end
end
