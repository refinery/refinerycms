module Refinery
  module Admin
    class PagePartsController < ::Refinery::AdminController
    helper Refinery::Admin::PagesHelper

      def new
          render :partial => '/refinery/admin/pages/new_page_part_field', :locals => {
           :title => params[:title], :body => params[:body], :index => params[:part_index]
         }
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
