module Refinery
  module Admin
    class ImagesController < ::Refinery::AdminController

      crudify :'refinery/image',
              include: [:translations, :crops],
              order: "updated_at DESC",
              sortable: false,
              conditions: 'parent_id IS NULL'

      before_action :change_list_mode_if_specified, :init_dialog

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
        @images = []
        begin
          if params[:image].present? && params[:image][:image].is_a?(Array)
            params[:image][:image].each do |image|
              image_title = params[:image][:image_title].presence || auto_title(image.original_filename)
              @images << @image = ::Refinery::Image.create(
                image_params.merge(image_title: image_title, image: image)
              )
            end
          else
            @images << (@image = ::Refinery::Image.create(image_params))
          end
        rescue NotImplementedError
          logger.warn($!.message)
          @image = ::Refinery::Image.new
        end

        if params[:insert]
          # if all uploaded images are ok redirect page back to dialog, else show current page with error
          if @images.all?(&:valid?)
            @image_id = @image.id if @image.persisted?
            @image = nil
          end

          self.insert
        else
          if @images.all?(&:valid?)
            flash.notice = t('created', scope: 'refinery.crudify', what: "'#{@images.map(&:image_title).join("', '")}'")
            if from_dialog?
              @dialog_successful = true
              render '/refinery/admin/dialog_success', layout: true
            else
              redirect_to refinery.admin_images_path
            end
          else
            self.new # important for dialogs
            render 'new'
          end
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
                redirect_back(fallback_location: { action: 'edit' })
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

      def crop
        parent_image = ::Refinery::Image.find_by_id(params[:image_id])

        cropped_image = ::Refinery::Image.new(
          parent_id: parent_image.id,
          image: params[:image]
        )

        if cropped_image.valid? && cropped_image.save!
          flash.notice = ::I18n.t('refinery.admin.images.form.crop_success')
          render json: {
            message: ::I18n.t('refinery.admin.images.form.crop_success'),
            crop: render_to_string('/refinery/admin/images/_crop', layout: false, locals: { crop: cropped_image})
          }
        else
          flash.now[:error] = ::I18n.t('refinery.admin.images.form.crop_error')
          render json: { message: ::I18n.t('refinery.admin.images.form.crop_error') }
        end
      end

      def destroy_crop
        @image = Refinery::Image.find_by_id(params[:image_id])
        title = @image.parent.image_name

        if @image.destroy
          flash.notice = t('destroyed', scope: 'refinery.crudify', what: title)

          respond_to do |format|
            format.js { render "/refinery/admin/images/destroy_crop", locals: { image_id: @image.id } }
          end
        end
      end

      protected

      def init_dialog
        @app_dialog = params[:app_dialog].present?
        @field = params[:field]
        @update_image = params[:update_image]
        @image_id = params[:selected_image].to_i if params[:selected_image].present?
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
        @images = @images.root.paginate(page: params[:page], per_page: Image.per_page(from_dialog?, !@app_dialog))
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
