class PagesController < ApplicationController

  def home
	  @page = Page.find_by_link_url("/")
	  error_404 if @page.nil?
  end

	def show
	  @page = Page.find(params[:id])
	end

end