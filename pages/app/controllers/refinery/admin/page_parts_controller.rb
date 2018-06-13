module Refinery
  module Admin
    class PagePartsController < ::Refinery::AdminController

      def new
        render :partial => '/refinery/admin/pages/page_part_field', :locals => {
                 :part => ::Refinery::PagePart.new(new_page_part_params),
                 :new_part => true,
                 :part_index => params[:part_index]
               }
      end

      def destroy
        part = ::Refinery::PagePart.find(params[:id])
        page = part.page
        if part.destroy
          page.reposition_parts!
          render plain: t('refinery.crudify.destroyed', what: "'#{part.title}'")
        else
          render plain: t('refinery.crudify.not_destroyed', what: "'#{part.title}'")
        end
      end

      protected
        def new_page_part_params
          params.except(:part_index).permit(permitted_new_page_part_params)
        end

      private
        def permitted_new_page_part_params
          [:title, :slug, :body]
        end
    end
  end
end
