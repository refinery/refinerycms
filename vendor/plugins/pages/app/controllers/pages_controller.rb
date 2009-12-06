class PagesController < ApplicationController

  def home
    @page = Page.find_by_link_url("/", :include => [:parts, :slugs])
    if @page.nil?
      error_404
    else
      respond_to do |wants|
        wants.html
      end
    end
  end

  def show
    @page = Page.find(params[:id], :include => [:parts, :slugs])

    if @page.live? or (logged_in? and current_user.authorized_plugins.include?("Pages"))
      # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
      if @page.skip_to_first_child
        first_live_child = @page.children.find_by_draft(false, :order => "position ASC")
        redirect_to first_live_child.url unless first_live_child.nil?
      else
        respond_to do |wants|
          wants.html
        end
      end
    else
      error_404
    end
  end

end
