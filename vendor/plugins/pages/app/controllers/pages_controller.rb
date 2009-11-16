class PagesController < ApplicationController

  def home
    @page = Page.find_by_link_url("/", :include => [:parts, :slugs])
    error_404 if @page.nil?
    
    respond_to do |wants|
      wants.html
    end
  end

  def show
    @page = Page.find(params[:id], :include => [:parts, :slugs])

    error_404 unless @page.live? or (logged_in? and current_user.authorized_plugins.include?("Pages"))

    # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
    if @page.skip_to_first_child
      first_live_child = @page.children.find_by_draft(false, :order => "position ASC")
      redirect_to first_live_child.url unless first_live_child.nil?
    end
    
    respond_to do |wants|
      wants.html
    end
  end

end