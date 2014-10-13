module Refinery
  module Admin
    class PagePartsController < ::Refinery::AdminController
    helper Refinery::Admin::PagesHelper

      def new
        render text: view_context.new_page_part('dummy', params[:title], params[:body], params[:part_index])
      end


      def destroy
        part = ::Refinery::PagePart.find(params[:id])
        page = part.page
        if part.destroy
          page.reposition_parts!
          render :text => "'#{part.title}' deleted."
        else
          render :text => "'#{part.title}' not deleted."
        end
      end

    end
  end
end
