class Admin::PagePartsController < Admin::BaseController

  def new
    render :partial => "/admin/pages/page_part_field", :locals => {
      :part => PagePart.new(:title => params[:title], :body => params[:body]),
      :new_part => true,
      :part_index => params[:part_index]
    }
  end

  def destroy
    part = PagePart.find(params[:id])
    if part.destroy
      render :text => "'#{part.title}' deleted."
    else
      render :text => "'#{part.title}' not deleted."
    end
  end

end
