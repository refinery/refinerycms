class PagesController < ApplicationController

  # This action is usually accessed with the root path, normally '/'
  def home
    error_404 unless (@page = Page.where(:link_url => '/').first).present?
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
    @page = Page.find("#{params[:path]}/#{params[:id]}".split('/').last)

    if @page.try(:live?) || (refinery_user? && current_user.authorized_plugins.include?("refinery_pages"))
      # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
      if @page.skip_to_first_child && (first_live_child = @page.children.order('lft ASC').live.first).present?
        redirect_to first_live_child.url
      elsif @page.link_url.present?
        redirect_to @page.link_url and return
      end
    else
      error_404
    end

    use_multi_layout = RefinerySetting.where(:name => "Multi Layout").first.value
    use_page_templates = RefinerySetting.where(:name => "Per Page Templates").first.value
    logger.debug("Use Multi Layout: #{use_multi_layout}")
    logger.debug("Use Per Page Templates #{use_multi_layout}")

    render_options = {}
    if use_multi_layout and not @page.layout.nil?
      render_options[:layout] = @page.layout.template_name
    end

    if use_page_templates and not @page.view_template.nil?
      render_options[:action] = @page.view_template
    end

    render render_options
  end

end
