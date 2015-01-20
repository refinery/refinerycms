module Refinery
  module Admin
    class ManualsController < ::Refinery::AdminController

      crudify :'refinery/manual'

      # overwriting crudified show
      def show
        #send_file(@manual.attachment, :type => 'application/pdf', :disposition => 'attachment') 
        send_data(@manual.attachment, :filename => @manual.filename, :type => @manual.mimetype, :disposition => "inline")
      end
            
      # overwriting crudified new
      def new
        @manual = ::Refinery::Manual.find_by_id(1)
        if @manual
          redirect_to refinery.edit_admin_manual_path(:id => 1)
        else
          @manual = ::Refinery::Manual.new
        end
      end

      # overwriting crudified create
      def create
        # There is only one manual, no translations. Hard coding the id makes sure that there will never be multiple manuals by some accident.
        # The params are assigned manually as create(params) requires more model attributes than is usefull for storing a manual.
        @manual = ::Refinery::Manual.new() do |item|
          item.id = 1
          item.title = params[:manual][:title]
          item.attachment = params[:manual][:attachment].read
          item.filename = params[:manual][:attachment].original_filename
          item.mimetype = params[:manual][:attachment].content_type
        end
        if @manual.save
          flash.notice = t(
          'refinery.crudify.created',
          :what => @manual[:title]
          )
          create_or_update_successful
        else
          create_or_update_unsuccessful 'new'
        end
      end

      # overwriting crudified edit
      def edit
        @manual = ::Refinery::Manual.find_by_id(1)
      end

      # overwriting crudified update
      def update
        # The params are assigned manually as update_attributes(params) requires more model attributes than is usefull for storing a manual.
        @manual.title = params[:manual][:title]
        if(params[:manual][:attachment])
          @manual.attachment = params[:manual][:attachment].read
          @manual.filename = params[:manual][:attachment].original_filename
          @manual.mimetype = params[:manual][:attachment].content_type
        end

        if @manual.save
          flash.notice = t(
                'refinery.crudify.updated',
                :what => @manual[:title]
              )
          create_or_update_successful
        else
          create_or_update_unsuccessful 'edit'
        end
      end


      def restrict_controller
        unless current_refinery_user.has_role?(:superuser)
          logger.warn "'#{current_refinery_user.username}' tried to access '#{params[:controller]}' but was rejected."
          error_404
        end
      end
    end
  end
end
