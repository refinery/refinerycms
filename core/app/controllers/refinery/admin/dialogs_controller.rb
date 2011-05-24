module ::Refinery
  module Admin
    class DialogsController < ::Admin::BaseController

      def show
        if (@dialog_type = params[:id].try(:downcase))
          url_params = params.reject {|key, value| key =~ /(action)|(controller)/}

          @iframe_src = if @dialog_type == 'image'
            main_app.insert_refinery_admin_images_path(url_params.merge(:id => nil, :modal => true))
          elsif @dialog_type == 'link'
            main_app.link_to_refinery_admin_pages_dialogs_path(url_params.merge(:id => nil))
          end

          render :layout => false

        else
          render :nothing => true
        end
      end

      def from_dialog?
        true
      end

    end
  end
end
