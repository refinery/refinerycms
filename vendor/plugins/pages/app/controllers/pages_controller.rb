class PagesController < ApplicationController

  caches_action :home, :show,
                :cache_path => Proc.new { |c| "#{c.request.host_with_port}/views/pages/#{c.params[:path]}" },
                :if => Proc.new { |c|
                  c.send(:logged_in?) == false and
                  (!RefinerySetting.table_exists? ||
                    RefinerySetting.find_or_set(:page_caching_enabled, true, :scoping => 'pages'))
                }

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

    if @page.try(:live?) or
       (refinery_user? and
        current_user.authorized_plugins.include?("refinery_pages"))
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
