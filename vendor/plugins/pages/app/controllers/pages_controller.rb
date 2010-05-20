class PagesController < ApplicationController

  def home
    error_404 unless (@page = Page.find_by_link_url("/", :include => [:parts, :slugs])).present?
  end

  # This action can be accessed normally, or as nested pages.
  # Assuming a page named "mission" that is a child of "about",
  # you can access the pages with the following URLs:
  #
  #   GET /pages/about
  #   GET /about
  #
  #   GET /pages/mission
  #   GET /about/mission
  #
  def show
    @page = if params[:path]
      Page.find(params[:path].last, :include => [:parts, :slugs])
    else
      Page.find(params[:id], :include => [:parts, :slugs])
    end

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
