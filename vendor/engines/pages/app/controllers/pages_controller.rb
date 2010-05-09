class PagesController < ApplicationController

  def home
    error_404 unless (@page = Page.find_by_link_url("/", :include => [:parts, :slugs])).present?
  end

  def show
    @page = Page.find(params[:id], :include => [:parts, :slugs])

    if @page.live? or (logged_in? and current_user.authorized_plugins.include?("Pages"))
      # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
      if @page.skip_to_first_child
        first_live_child = @page.children.find_by_draft(false, :order => "position ASC")
        redirect_to first_live_child.url if first_live_child.present?
      end
    else
      error_404
    end
  end

end
