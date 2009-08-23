class PagesController < ApplicationController

  def home
	  @page = Page.find_by_link_url("/", :include => [:parts, :slugs])
	  error_404 if @page.nil?
  end

	def show
	  @page = Page.find(params[:id], :include => [:parts, :slugs])
		
		error_404 unless @page.live?
		
		# if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
		if @page.skip_to_first_child
			first_live_child = @page.children.find_by_draft(false, :order => "position ASC")
			redirect_to page_url(first_live_child) unless first_live_child.nil?
		end
	end

end