module ::Refinery
  module Admin
    class ImagesController < ::Refinery::AdminController

      crudify :'refinery/image',
              :order => "created_at DESC",
              :sortable => false,
              :xhr_paging => true

      before_filter :change_list_mode_if_specified, :init_dialog

      def new
        @image = ::Refinery::Image.new if @image.nil?

        @url_override = main_app.refinery_admin_images_path(:dialog => from_dialog?)
      end

      # This renders the image insert dialog
      def insert
        self.new if @image.nil?

        @url_override = main_app.refinery_admin_images_path(request.query_parameters.merge(:insert => true))

        if params[:conditions].present?
          extra_condition = params[:conditions].split(',')

          extra_condition[1] = true if extra_condition[1] == "true"
          extra_condition[1] = false if extra_condition[1] == "false"
          extra_condition[1] = nil if extra_condition[1] == "nil"
        end

        find_all_images(({extra_condition[0].to_sym => extra_condition[1]} if extra_condition.present?))
        search_all_images if searching?

        paginate_images

        render :action => "insert"
      end

      def create
        begin
          @images = images_from_params

          @image = @images.last
        rescue Dragonfly::FunctionManager::UnableToHandle
          logger.warn($!.message)
          @image = ::Refinery::Image.new
        end

        unless params[:insert]
          if @images.all?{|i| i.valid?}
            flash.notice = t('created', :scope => 'refinery.crudify', :what => "'#{@images.collect{|i| i.title}.join("', '")}'")
            unless from_dialog?
              redirect_to main_app.url_for(:action => 'index')
            else
              render :text => "<script>parent.window.location = '#{main_app.refinery_admin_images_path}';</script>"
            end
          else
            self.new # important for dialogs
            render :action => 'new'
          end
        else
          # if all uploaded images are ok redirect page back to dialog, else show current page with error
          if @images.all?{|i| i.valid?}
            @image_id = @image.id if @image.persisted?
            @image = nil

            redirect_to main_app.insert_refinery_admin_images_path(request.query_parameters)
          else
            self.insert
          end
        end
      end

    protected

      def images_from_params
        image_params.map { |image| ::Refinery::Image.create image }
      end

      def image_params
        case
        when params[:image].nil?
          []
        when params[:image][:image].nil?
          [params[:image]]
        else
          alt = params[:image][:alt]

          params[:image][:image].dup.map! do |image|
            { :image => image, :alt => alt }
          end
        end
      end

      def init_dialog
        @app_dialog = params[:app_dialog].present?
        @field = params[:field]
        @update_image = params[:update_image]
        @thumbnail = params[:thumbnail]
        @callback = params[:callback]
        @conditions = params[:conditions]
      end

      def change_list_mode_if_specified
        if action_name == 'index' and
           params[:view].present? and
           ::Refinery::Setting.get(:image_views).include?(params[:view].to_sym)
          ::Refinery::Setting.set(:preferred_image_view, params[:view])
        end
      end

      def paginate_images
        @images = @images.paginate(:page => params[:page], :per_page => Image.per_page(from_dialog?, !@app_dialog))
      end

      def restrict_controller
        super unless action_name == 'insert'
      end

      def store_current_location!
        super unless action_name == 'insert' or from_dialog?
      end

    end
  end
end
