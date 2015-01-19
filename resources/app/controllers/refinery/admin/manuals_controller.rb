module Refinery
  module Admin
    class ManualsController < ::Refinery::AdminController

      crudify :'refinery/manual'
            
      # overwriting crudified new
      def new
        @manual = ::Refinery::Manual.find_by_id(1)
        if @manual
          redirect_to refinery.edit_resources_admin_manual_path(:id => 1)
        else
          @manual = ::Refinery::Manual.new
        end
      end

      # overwriting crudified create
      def create
        # There is only one PageInfo object with several translations.
        # In the unlikely case that it will be deleted manually from the databse,
        # ensure that the newly created PageInfo object will always have the id 1,
        # as this is hard coded in several places.
        @manual = ::Refinery::Manual.new(params[:manual]) do |item|
          item.id = 1
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


      def restrict_controller
        unless current_refinery_user.has_role?(:superuser)
          logger.warn "'#{current_refinery_user.username}' tried to access '#{params[:controller]}' but was rejected."
          error_404
        end
      end
    end
  end
end
