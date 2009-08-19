class PagesController < ApplicationController

  def home
	  @page = Page.find_by_link_url("/", :include => [:parts, :slugs, :children])
	  error_404 if @page.nil?
  end

	def show
	  @page = Page.find(params[:id], :include => [:parts, :slugs, :children])
	end

end