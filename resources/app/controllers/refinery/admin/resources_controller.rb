module Refinery
  module Admin
    class ResourcesController < ::Refinery::AdminController

      crudify :'refinery/resource',
              include: [:translations],
              order: "updated_at DESC",
              sortable: false

      before_action :init_dialog

      def new
        @resource = Resource.new if @resource.nil?

        @url_override = refinery.admin_resources_path(:dialog => from_dialog?)
      end

      def create
        @resources = Resource.create_resources(resource_params)
        @resource = @resources.detect { |r| !r.valid? }

        if params[:insert]
          if @resources.all?(&:valid?)
            @resource_id = @resources.detect(&:persisted?).id
            @resource = nil

            self.insert
          end
        else
          if @resources.all?(&:valid?)
            flash.notice = t('created', :scope => 'refinery.crudify', :what => "'#{@resources.map(&:title).join("', '")}'")
            if from_dialog?
              @dialog_successful = true
              render '/refinery/admin/dialog_success', layout: true
            else
              redirect_to refinery.admin_resources_path
            end
          else
            self.new # important for dialogs
            render 'new'
          end
        end
      end

      def insert
        self.new if @resource.nil?
        @url_override = refinery.admin_resources_path(request.query_parameters.merge(insert: true))

        if params[:conditions].present?
          extra_condition = params[:conditions].split(',')

          extra_condition[1] = true if extra_condition[1] == "true"
          extra_condition[1] = false if extra_condition[1] == "false"
          extra_condition[1] = nil if extra_condition[1] == "nil"
        end

        find_all_resources(({extra_condition[0] => extra_condition[1]} if extra_condition.present?))
        search_all_resources if searching?

        paginate_resources

        @resource_area_selected = from_dialog?

        if params[:visual_editor]
          render '/refinery/admin/pages_dialogs/link_to' 
        else 
          render 'insert' 
        end
      end

      protected

      def init_dialog
        @app_dialog = params[:app_dialog].present?
        @field = params[:field]
        @update_resource = params[:update_resource]
        @update_text = params[:update_text]
        @thumbnail = params[:thumbnail]
        @callback = params[:callback]
        @conditions = params[:conditions]
        @current_link = params[:current_link]
      end

      def restrict_controller
        super unless action_name == 'insert'
      end

      def paginate_resources
        @resources = @resources.paginate(page: params[:page], per_page: Resource.per_page(from_dialog?))
      end

      def resource_params
        # update only supports a single file, create supports many.
        if action_name == 'update'
          params.require(:resource).permit(permitted_update_resource_params)
        else
          params.require(:resource).permit(permitted_resource_params)
        end
      end

      private

      def permitted_resource_params
        [
          :resource_title, :file => []
        ]
      end

      def permitted_update_resource_params
        [
          :resource_title, :file
        ]
      end

    end
  end
end
