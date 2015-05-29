module Refinery
  module Admin
    class ImagesController < ::Refinery::AdminController

      crudify :'refinery/image',
              include: [:translations],
              order: "updated_at DESC",
              sortable: false

      before_action :change_list_mode_if_specified, :init_dialog
      before_filter :redirect_index_view, only: [:index]

      def new
        @image = ::Refinery::Image.new if @image.nil?

        @url_override = refinery.admin_images_path(dialog: from_dialog?)
      end

      # This renders the image insert dialog
      def insert
        self.new if @image.nil?

        @url_override = refinery.admin_images_path(request.query_parameters.merge(insert: true))

        if params[:conditions].present?
          extra_condition = params[:conditions].split(',')

          extra_condition[1] = true if extra_condition[1] == "true"
          extra_condition[1] = false if extra_condition[1] == "false"
          extra_condition[1] = nil if extra_condition[1] == "nil"
        end

        find_all_images(({extra_condition[0] => extra_condition[1]} if extra_condition.present?))
        search_all_images if searching?

        paginate_images

        render 'insert'
      end

      def create

        begin
          @image = ::Refinery::Image.create(:image => params[:image][:image])
        rescue Dragonfly::FunctionManager::UnableToHandle
          logger.warn($!.message)
          @image = ::Refinery::Image.new
        rescue Exception => e
          logger.warn e
          return render json: {image_id: nil, message: 'Something went wrong', errors: [e]}, status: 500
        end

        if @image.valid?
          return render json: {image_id: @image.id, message: 'created!', url: @image.thumbnail({geometry: '1400x>'}).url}, status: 200
        else
          return render json: {image_id: nil, message: 'validation failed', errors: @image.errors}, status: 400
        end

      end

      def update
        @image.attributes = image_params
        if @image.valid? && @image.save
          flash.notice = t('refinery.crudify.updated', what: "'#{@image.title}'")

          if from_dialog?
            self.index
            @dialog_successful = true
            render :index
          else
            if params[:continue_editing] =~ /true|on|1/
              if request.xhr?
                render partial: '/refinery/message'
              else
                redirect_to :back
              end
            else
              redirect_back_or_default refinery.admin_images_path
            end
          end
        else
          @thumbnail = Image.find params[:id]
          if request.xhr?
            render partial: '/refinery/admin/error_messages', locals: {
                     object: @image,
                     include_object_name: true
                   }
          else
            render 'edit'
          end
        end
      end

      def destroy
        begin
          ::Refinery::Image.find(params[:id]).destroy
          return render json: {image_id: nil, old_id: params[:id], message: 'image removed', status: 200}
        rescue
          return render json: {image_id: nil, old_id: params[:id], message: 'Something went wrong', status: 500}
        end
      end

    protected
      def redirect_index_view
        error_404
      end

      def init_dialog
        @app_dialog = params[:app_dialog].present?
        @field = params[:field]
        @update_image = params[:update_image]
        @thumbnail = params[:thumbnail]
        @callback = params[:callback]
        @multiple = params[:multiple]
        @conditions = params[:conditions]
      end

      def change_list_mode_if_specified
        if action_name == 'index' && params[:view].present? && Refinery::Images.image_views.include?(params[:view].to_sym)
           Refinery::Images.preferred_image_view = params[:view]
        end
      end

      def paginate_images
        @images = @images.paginate(page: params[:page], per_page: Image.per_page(from_dialog?, !@app_dialog))
      end

      def restrict_controller
        super unless action_name == 'insert'
      end

      def auto_title(filename)
        CGI::unescape(filename.to_s).gsub(/\.\w+$/, '').titleize
      end

      def image_params
        params.require(:image).permit(permitted_image_params)
      end

      private

      def permitted_image_params
        [
          :image, :image_size, :image_title, :image_alt
        ]
      end

    end
  end
end
